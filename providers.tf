# Order Domino's using Terraform

terraform {
  required_providers {
    dominos = {
      source  = "the-noid/dominos"
      version = "0.1.0"
    }
  }
}

provider "dominos" {
  first_name    = "My"
  last_name     = "Name"
  email_address = "myname@name.com"
  phone_number  = "15555555555"

  credit_card {
    number = var.credit_card
    cvv    = 123
    date   = "01/23"
    zip    = 45678
  }
}

variable "credit_card" {
  type = number
}

output "OrderOutput" {
  value = data.dominos_menu_item.item.matches[*]
}

data "dominos_address" "addr" {
  street = "123 Anywhere St"
  city   = "Anywhere"
  state  = "MN"
  zip    = "12345"
}

data "dominos_store" "store" {
  address_url_object = data.dominos_address.addr.url_object
}

data "dominos_menu_item" "item" {
  store_id     = data.dominos_store.store.store_id
  # query_string = ["buffalo", "large", "thin"]
  # query_string = ["philly", "medium", "hand"]
  query_string = ["ultimate", "large", "thin"]
  # query_string = ["buffalo", "sandwich"]
  # query_string = ["chicken", "parm", "sandwich"]
  # query_string = ["buffalo", "16-piece", "wings"]
  # query_string = ["buffalo", "32-piece", "wings"]
}

resource "dominos_order" "order" {
  address_api_object = data.dominos_address.addr.api_object
  item_codes         = ["${data.dominos_menu_item.item.matches.0.code}"]
  store_id           = data.dominos_store.store.store_id
}
