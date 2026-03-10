# =============================================================================
# API Gateway Resource Policy — Layer 5: Cloudflare IP Restriction
# =============================================================================
# API GW の Resource Policy で Cloudflare IP 以外からのアクセスを全拒否。
# API GW の URL が漏洩しても外部からアクセス不可。
#
# Source: https://www.cloudflare.com/ips-v4/ / https://www.cloudflare.com/ips-v6/
# Last verified: 2026-03-04
# Check periodically: curl -s https://www.cloudflare.com/ips-v4
#                     curl -s https://www.cloudflare.com/ips-v6
# =============================================================================

locals {
  cloudflare_ip_ranges = [
    # IPv4
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
    # IPv6
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32",
  ]
}

# Resource Policy を別リソースで管理
# （agent_api の lifecycle { ignore_changes = [policy] } と干渉しない）
resource "aws_api_gateway_rest_api_policy" "agent_api" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "execute-api:Invoke"
        Resource  = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = local.cloudflare_ip_ranges
          }
        }
      }
    ]
  })
}
