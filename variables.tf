variable "library_name" {
  type        = string
  description = "Name of the Node.js library to create Lambda Layer"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,64}$", var.library_name))
    error_message = "Provide a valid library name. Library name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters."
  }
}

variable "layer_name" {
  type        = string
  description = "Name of Lambda layer"
  default     = "null"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z\\-\\_0-9]{1,64}$", var.layer_name))
    error_message = "Lambda Layer name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters."
  }
}

variable "nodejs_runtime" {
  type        = string
  default     = "nodejs20.x"
  description = "Runtime identifier for the Lambda Layer. eg. nodejs20.x, nodejs18.x, nodejs16.x"
  validation {
    condition     = contains(["nodejs20.x", "nodejs18.x", "nodejs16.x", null], var.nodejs_runtime)
    error_message = "Unsupported runtime <${var.nodejs_runtime}>"
  }
}
