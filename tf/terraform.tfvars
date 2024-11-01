env = {
  region  = "us-east-1"
  profile = "default"
  account_id = "@@INSERT_ACCOUNT_ID@@"
}

sqs_queue_name = ""
sqs_arn = ""

function_name = ""
function_arn = ""


sqs_trigger_arns={
    "${var.sqs_queue_name}": "${var.sqs_arn}",
}

sqs_queues = {
    "${sqs_queue_name}": {
        "name": "${sqs_queue_name}",
        "fifo_queue": true,
        "content_based_deduplication": true,
        "visibility_timeout_seconds": 300,
    },
  }

  success_queue = ""
  failure_queue = ""