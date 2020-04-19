import logging

from json_logger import setup_logging, set_log_record_field
import airflow.configuration

setup_logging(
    service_name='airflow',
    environment_name='dev'
)

airflow.configuration.log = logging.getLogger(__name__)

