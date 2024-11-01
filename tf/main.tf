###Create for each chain from same source code

data "archive_file" "index_zip" {
    type        = "zip"
   # source_file  = "${path.cwd}/../index.ts"
  source {
    filename = "${basename(local.source_files[0])}"
    content  = "${file(element(local.source_files, 0))}"
  }

  source {
    filename = "${basename(local.source_files[1])}"
    content  = "${file(element(local.source_files, 1))}"
  }
    output_path = "${path.cwd}/dist/index.zip"
}

resource "aws_lambda_function" "create_lambdas" {
  for_each      = local.lambda_settings

  filename         = "${path.cwd}/dist/index.zip"
  function_name    = "${var.function_name}"
  role             = "arn:aws:iam::961171757719:role/service-role/export-execute-txn-role-9eweg0cc"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.index_zip.output_base64sha256}"
  runtime          = "nodejs16.x"
  timeout          = 480
  memory_size      = 300


}

locals {
 source_files = ["${path.cwd}/../dist/index.js", "${path.cwd}/../dist/index.js.map"]

 lambda_settings = {
    "${var.function_name}"  = {  
                    sqs_trigger_arns=var.sqs_trigger_arns["${var.sqs_queue_name}"],
                    EXPORT_SUCCESS_ARN="${var.success_queue}",
                    EXPORT_FAILURE_ARN="${var.failure_queue}"
                },
  }
}

resource "aws_sqs_queue" "$${var.sqs_queue_name}" {
  name = "${var.sqs_queue_name}"
  fifo_queue = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  for_each      = local.lambda_settings
  event_source_arn = var.sqs_trigger_arns["${var.sqs_queue_name}"]
  enabled          = true
  function_name    = "${var.function_arn}" #arn
  batch_size       = 1
}


