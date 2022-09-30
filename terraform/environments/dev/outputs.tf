output "service_arn" {
  description = "The App Runner Service ARN"
  value       = module.kata.service_arn
}

output "service_url" {
  description = "The App Runner Service URL"
  value       = module.kata.service_url
}

output "service_status" {
  description = "The App Runner Service Status"
  value       = module.kata.service_status
}
