output "service_arn" {
  description = "The App Runner Service ARN"
  value       = module.test.service_arn
}

output "service_url" {
  description = "The App Runner Service URL"
  value       = module.test.service_url
}

output "service_status" {
  description = "The App Runner Service Status"
  value       = module.test.service_status
}
