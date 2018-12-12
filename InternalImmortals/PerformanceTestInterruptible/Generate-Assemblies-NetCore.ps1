# Perform the code-generation step for this example application.

if (-not ( $env:AMBVARIANTCORE )) {
    $env:AMBVARIANTCORE="x64\Debug\netcoreapp2.0"
}

# Build the API projects
& dotnet publish "API\ServerAPI.csproj" -f "netcoreapp2.0"
& dotnet publish "IJob\IJob.csproj" -f "netcoreapp2.0"

# Create the dependencies folder
New-Item -ItemType Directory -Force -Path "CodeGenDependencies\netcoreapp2.0"
Get-ChildItem "CodeGenDependencies\netcoreapp2.0" | Remove-Item
Copy-Item "API\bin\Debug\netcoreapp2.0\publish\*" -Force -Destination "CodeGenDependencies\netcoreapp2.0\"
# DANGER, WARNING, FIXME: it is UNSAFE to MERGE the outputs of two publish directories:
Copy-Item "IJob\bin\Debug\netcoreapp2.0\publish\*" -Force -Destination "CodeGenDependencies\netcoreapp2.0\"

Copy-Item "..\..\Clients\CSharp\AmbrosiaCS\AmbrosiaCS.csproj" -Force -Destination "CodeGenDependencies\netcoreapp2.0\"

Write-Host "Using variant of AmbrosiaCS.exe: $env:AMBVARIANTCORE"

Write-Host "Executing codegen command: dotnet ..\..\Clients\CSharp\AmbrosiaCS\bin\$env:AMBVARIANTCORE\AmbrosiaCS.dll CodeGen -a=API\bin\$env:AMBVARIANTCORE\ServerAPI.dll -a=IJob\bin\$env:AMBVARIANTCORE\IJob.dll -o=PTIAmbrosiaGeneratedAPINetCore -f=netcoreapp2.0 -b=CodeGenDependencies\netcoreapp2.0"

# Generate the assemblies, assumes an .exe which is created by a .Net Framework build:
& dotnet "..\..\Clients\CSharp\AmbrosiaCS\bin\$env:AMBVARIANTCORE\AmbrosiaCS.dll" CodeGen -a="API\bin\$env:AMBVARIANTCORE\ServerAPI.dll" -a="IJob\bin\$env:AMBVARIANTCORE\IJob.dll" -o="PTIAmbrosiaGeneratedAPINetCore" -f="netcoreapp2.0" -b="CodeGenDependencies\netcoreapp2.0"
