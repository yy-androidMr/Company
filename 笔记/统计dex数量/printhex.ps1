<#
.SYNOPSIS
Outputs the number of methods in a dex file.

.PARAMETER Path
Specifies the path to a file. Wildcards are not permitted.

#>
param(
  [parameter(Position=0,Mandatory=$TRUE)]
    [String] $Path
)

if ( -not (test-path -literalpath $Path) ) {
  write-error "Path '$Path' not found." -category ObjectNotFound
  exit
}

$item = get-item -literalpath $Path -force
if ( -not ($? -and ($item -is [System.IO.FileInfo])) ) {
  write-error "'$Path' is not a file in the file system." -category InvalidType
  exit
}

if ( $item.Length -gt [UInt32]::MaxValue ) {
  write-error "'$Path' is too large." -category OpenError
  exit
}

$stream = [System.IO.File]::OpenRead($item.FullName)
$buffer = new-object Byte[] 2
$stream.Position = 88
$bytesread = $stream.Read($buffer, 0, 2)
$output = $buffer[0..1] 
#("{1:X2} {0:X2}") -f $output
$outputdec = $buffer[1]*256 + $buffer[0]
"Number of methods is " + $outputdec
$stream.Close()

作者：dongjunkun
链接：https://www.jianshu.com/p/366b3ae72be6
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。