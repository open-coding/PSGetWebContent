# PSGetWebContent

## A powershell module for getting web content
I wrote that powershell module because I couldn't find any module or cmdlet that could tail the content of a web file. This module exports the cmdlet `Get-WebContent` which works with servers that accept `byte` ranges:
 * Header `accept-ranges=bytes`

It comes with a `-Wait` switch so that its able to get new content if the file you are getting changes onto the server. This is extremely helpful if you'd like to watch a log-file. It's like the powershell cmdlet `Get-Content` for the web and like a mixture of `wget` and `tail` from unix.

### Installation

Simply download the whole `PSGetWebContent` folder to `C:\Users\<username>\Documents\WindowsPowerShell\Modules\`

### Usage
| Command | Description |
| ------------- | ------------- |
| `Get-WebContent http://myserver/access.log`  | gets the whole content of the file  |
| `Get-WebContent http://myserver/access.log -TailKiloBytes 2`  | gets the last two kilobytes of the file  |
| `Get-WebContent http://myserver/access.log -Wait` | gets the whole content of the file and waits for more |
| `Get-WebContent http://myserver/access.log -Wait -TailKiloBytes 2` | gets the last two kilobytes of the file and waits for more |
