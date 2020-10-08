import json
import datetime
import requests

from ..exceptions.loan import LoanException
from ..services.loan import LoanService
from ..serializers import CreditProcessSerializer, LoanInsertResponseSerializer, LoanStatusSerializer


def alive(event, context):
    body = {
        "message": "alive"
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response

def post(self, request):
    params = request.data.copy()

    try:
        # Process all rules and insert into database
        data = LoanService().insert(params)

        # Send to pipline for processing
        loan = CreditProcessSerializer(data)
        run_credit_pipeline(loan.data)

        # Serialize the data
        serialized = LoanInsertResponseSerializer(data)

        return Response(serialized.data)
    except LoanException as e:
        raise ValidationError(detail=e)


def get(self, request, loan_id):
    data = LoanService().get_result(loan_id)
    serialized = LoanStatusSerializer(data)

    return Response(serialized.data)