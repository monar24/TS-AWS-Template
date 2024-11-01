variable "env" {
  type    = map(any)
  default = {}
}

variable "sqs_trigger_arns" {
    default = {}
    description = "List of SQS queue ARNs to act as lambda triggers"
    type        = map
}

variable sqs_queues {
    type = any
    description = "A map of SQS queue names to SQS queue configurations."
}

variable sqs_queue_name { 
  type = string 
  description = "queue name"
}

variable sqs_arn { 
  type = string 
  description = "sqs_arn"
}

variable function_name {
  type = string 
  description = "name of lambda function"
}

variable function_arn {
  type = string 
  description = "arn of lambda function"
}

variable success_queue {
  type = string 
  description = "arn of success queue"
}

variable failure_queue {
  type = string 
  description = "arn of failure queue"
}