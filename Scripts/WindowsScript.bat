@echo off

set /p pemFilePath=Enter .pem file path:
set /p zipFilePath=Enter Validator Key zip file path:
set /p instanceCredential=Enter AWS public IPv4 and external DNS hostname[eg: ec2-user@ec2-x-xx-xxx-xxx.compute-1.amazonaws.com]:

icacls.exe "%pemFilePath%" /reset
icacls.exe "%pemFilePath%" /GRANT:R "%USERNAME%:(R)"
icacls.exe "%pemFilePath%" /inheritance:r


scp -i %pemFilePath% -r %zipFilePath% %instanceCredential%:/home/ec2-user



ssh -i %pemFilePath% %instanceCredential%