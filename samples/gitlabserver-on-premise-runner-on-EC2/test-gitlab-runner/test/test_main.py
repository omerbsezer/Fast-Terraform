import pytest 
from src.main import func

def test_answer():
    assert func(3) == 4
