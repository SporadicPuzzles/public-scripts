param (
    [string]$sourceFolder,
    [string]$outputFile
)


$sourceFolder = (Resolve-Path -Path $sourceFolder).Path

$filesByExtension = @{}

Get-ChildItem -Path $sourceFolder -File -Recurse | ForEach-Object {
    $file = $_
    $extension = $file.Extension.TrimStart('.')

    if (-not $filesByExtension.ContainsKey($extension)) {
        $filesByExtension[$extension] = @()
    }

    if (-not $sourceFolder.EndsWith('\')) {
        $sourceFolder += '\'
    }

    $relativePath = $file.FullName.Substring($sourceFolder.Length).TrimStart('\')
    $filesByExtension[$extension] += $relativePath
}

$markdownContent = "# Files sorted by extension`n`n"

$sortedExtensions = $filesByExtension.Keys | Sort-Object
foreach ($extension in $sortedExtensions) {
    $fileCount = $filesByExtension[$extension].Count
    $markdownContent += "## Extension : $extension ($fileCount files)`n`n"
    $sortedFiles = $filesByExtension[$extension] | Sort-Object
    foreach ($file in $sortedFiles) {
        $markdownContent += "- $file`n"
    }
    $markdownContent += "`n"
}

$markdownContent | Out-File -FilePath $outputFile -Encoding utf8
Write-Output "Generated file: $outputFile"
