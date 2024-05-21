from unittest.mock import Mock
from app.app import lambda_handler


def test_lambda_handler_returns_1():
    mock_event = Mock()
    mock_context = Mock()

    assert lambda_handler(mock_event, mock_context) == 3
