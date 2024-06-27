import numpy as np


def lambda_handler(event, _context):
    return np.random.rand()
