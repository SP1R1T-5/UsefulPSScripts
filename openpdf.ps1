function Open-PDF {
    param (
        [string]$FilePath
    )

    # Define the path to Acrobat Reader
    $acrobatPath = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

    # Check if the file exists
    if (Test-Path $FilePath) {
        Start-Process -FilePath $acrobatPath -ArgumentList "`"$FilePath`""
    }
    else {
        Write-Host "File not found: $FilePath" -ForegroundColor Red
    }
}

# Create an alias for the function
Set-Alias -Name openpdf -Value Open-PDF

#Jon Fortnite
