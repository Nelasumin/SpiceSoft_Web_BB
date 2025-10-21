param(
  [int]$Port = 8011,
  [string]$Root = (Get-Location).Path
)

Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $Root on http://localhost:$Port/"

function Get-MimeType {
  param([string]$Path)
  $ext = [System.IO.Path]::GetExtension($Path).ToLower()
  switch ($ext) {
    ".html" { return "text/html" }
    ".css"  { return "text/css" }
    ".js"   { return "application/javascript" }
    ".ico"  { return "image/x-icon" }
    ".png"  { return "image/png" }
    ".jpg"  { return "image/jpeg" }
    ".jpeg" { return "image/jpeg" }
    default  { return "application/octet-stream" }
  }
}

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $localPath = $ctx.Request.Url.AbsolutePath.TrimStart('/')
  if ([string]::IsNullOrWhiteSpace($localPath)) { $localPath = 'index.html' }
  $filePath = Join-Path $Root $localPath

  if (Test-Path $filePath) {
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $ctx.Response.ContentType = Get-MimeType -Path $filePath
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $ctx.Response.Close()
  }
  else {
    $ctx.Response.StatusCode = 404
    $ctx.Response.Close()
  }
}