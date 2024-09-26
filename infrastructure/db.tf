resource "aws_dynamodb_table" "my_table" {
  name           = "compie-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = merge(local.tags, { Name = "${local.tags.Environment}-dynamodb-table" })
}
