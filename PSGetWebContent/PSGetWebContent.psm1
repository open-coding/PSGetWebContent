#$logURL = "https://www.wesser.de/fileadmin/logfile_dir/logfile.log"

function Get-CurrentContentLength($url){
    $response = wget $url -Method Head
    return [double] $response.Headers.'Content-Length'
}

function Get-WebContent {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$URL,
        [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [double]$TailKiloBytes=100,
        [Switch]$Wait,
        [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [int]$SleepInMilliseconds=1000
    )
    
    PROCESS {

        $response = wget $URL -Method Head -DisableKeepAlive
        $tail = 1024 * $TailKiloBytes

        if($response.Headers.'Accept-Ranges' -eq 'bytes'){
    
    
            [double] $currentContentLength = $response.Headers.'Content-Length'

            $request = [System.Net.WebRequest]::Create($URL)
            [int] $start = ($currentContentLength-$tail)
            Write-Verbose "Requesting $URL from byte $start till $currentContentLength"
            [int] $end = $currentContentLength
            $request.AddRange( $start, $end)
            $response = $request.GetResponse()
            $reader = [System.IO.StreamReader]::new($response.GetResponseStream())
            try {
                while($line = $reader.ReadLine()) {
                    $line
                    Write-Verbose "reading line"
                } 
            } finally {
                Write-Verbose "closing reader"
                $reader.Close()
            }
            [double] $lastContentLength = $currentContentLength


            while($Wait) {

                $currentContentLength = Get-CurrentContentLength $URL

                if($lastContentLength -eq $currentContentLength) {
                     Write-Verbose "Sleeping $SleepInMilliseconds milliseconds..."
                     sleep -Milliseconds $SleepInMilliseconds
                } else {
                    $request = [System.Net.WebRequest]::Create($URL)
                    Write-Verbose "Requesting $URL from byte $lastContentLength till end of file"
                    $request.AddRange($lastContentLength)
                    $response = $request.GetResponse()
                    $reader = [System.IO.StreamReader]::new($response.GetResponseStream(), [System.Text.Encoding]::UTF8)
                    try {
                        while($line = $reader.ReadLine()) {
                            $line
                        }
                    } finally {
                        Write-Verbose "closing reader"
                        $reader.Close()
                    }
                    $lastContentLength = $currentContentLength
                }
            }

        } else {

           Write-Warning "Server doesn't accept byte range"

        }

    }
}

Export-ModuleMember -Function Get-WebContent




