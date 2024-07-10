# Use the Windows Server Core base image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /src
COPY ["SampleWeb/SampleWeb.csproj", "SampleWeb/"]
RUN dotnet restore "SampleWeb/SampleWeb.csproj"
COPY . .
WORKDIR "/src/SampleWeb"
RUN dotnet build "SampleWeb.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SampleWeb.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["SampleWeb.exe"]  # Update the entry point for Windows
