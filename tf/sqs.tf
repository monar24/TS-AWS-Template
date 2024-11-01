resource "aws_sqs_queue" "queue" {
    for_each = var.sqs_queues

    name = lookup(each.value, "name")
    delay_seconds = lookup(each.value, "delay_seconds", 0)
    max_message_size = lookup(each.value, "max_message_size", 262144)
    message_retention_seconds = lookup(each.value, "message_retention_seconds", 345600)
    receive_wait_time_seconds = lookup(each.value, "receive_wait_time_seconds", 0)
    visibility_timeout_seconds = lookup(each.value, "visibility_timeout_seconds", 30)
    content_based_deduplication = lookup(each.value, "content_based_deduplication", false)
    fifo_queue = lookup(each.value, "fifo_queue", false)
    fifo_throughput_limit = lookup(each.value, "fifo_throughput_limit", "perMessageGroupId")
    deduplication_scope = lookup(each.value, "deduplication_scope", "messageGroup")
}

data "aws_iam_policy_document" "policy" {
    for_each = var.sqs_queues

    policy_id = "sqs.${aws_sqs_queue.queue[each.key].arn}.policy"
    statement {
        sid = "sqs_${each.key}_sid"

        principals {
            type = "AWS"
            identifiers = ["*"]
        }

        actions = [
            "SQS:SendMessage",
            "SQS:ReceiveMessage",
            "SQS:DeleteMessage",
            "SQS:GetQueueUrl",
            "SQS:ListQueues",
            "SQS:ListQueueTags",
            "SQS:ListDeadLetterSourceQueues",
        ]

        resources = [
            aws_sqs_queue.queue[each.key].arn
        ]

        effect = "Allow"

        condition {
            test = "ArnEquals"
            variable = "aws:SourceArn"
            values = concat(lookup(each.value, "allowed_source_arns", []), ["arn:aws:sns:${var.env["region"]}:${var.env["account_id"]}:*"])
        }
    }
    depends_on = [aws_sqs_queue.queue]
}

resource "aws_sqs_queue_policy" "policy" {
    for_each = var.sqs_queues

    queue_url = aws_sqs_queue.queue[each.key].id
    policy = data.aws_iam_policy_document.policy[each.key].json
    depends_on = [aws_sqs_queue.queue]
}