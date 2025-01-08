" Various Producibles for main program/base class log messages "

# imports
import datetime, json
from ..kafka_wrapper import Producible
from .log_handler import LoggingHandler

class LogProducible(Producible):
    """A Producible for log messages. The key is a program ID and the value
    are all of the logs (as provided by handler)
    """

    def __init__(self, program_id):
        self.__program_id = program_id

    @property
    def msg_key(self):
        return f"{self.__program_id}_log"

    @property
    def msg_value(self):
        return LoggingHandler.get_messages(self.__program_id)
