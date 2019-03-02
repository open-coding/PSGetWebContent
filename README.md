# PSGetWebContent

## A powershell module for getting web content
I wrote that powershell module because I couldn't find any module or cmdlet that could tail the content of a web file. This module exports the cmdlet `Get-WebContent` which works with servers that accept `byte` ranges:
 * Header `accept-ranges=bytes`

It comes with a `-Wait` switch so that its able to get new content if the file you are getting changes onto the server. This is extremely helpful if you'd like to watch a log-file. It's like `Get-Content` for the web.

### Installation

Simply download the whole `PSGetWebContent` folder to `C:\Users\<username>\Documents\WindowsPowerShell\Modules\`

### Usage

`Get-WebContent http://myserver/server.log`

`Get-WebContent http://myserver/server.log -TailKiloBytes 2`

`Get-WebContent http://myserver/server.log -Wait`

`Get-WebContent http://myserver/server.log -Wait -TailKiloBytes 2`

