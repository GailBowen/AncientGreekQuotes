# Use the .NET Core SDK base image for building
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["SampleWeb/SampleWeb.csproj", "SampleWeb/"]
RUN dotnet restore "SampleWeb/SampleWeb.csproj"
COPY . .
WORKDIR "/src/SampleWeb"
RUN dotnet build "SampleWeb.csproj" -c Release -o /app

# Publish the application
FROM build AS publish
RUN dotnet publish "SampleWeb.csproj" -c Release -o /app

# Use the Windows Nano Server base image for the final runtime image
FROM mcr.microsoft.com/windows/nanoserver:1809 AS final
WORKDIR /app
COPY --from=publish /app .
EXPOSE 80 443
ENTRYPOINT ["SampleWeb.exe"]
