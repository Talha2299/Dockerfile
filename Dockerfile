FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["PartnerPortalCore.csproj", "PartnerPortalCore/"]
RUN dotnet restore "PartnerPortalCore/PartnerPortalCore.csproj"
COPY . .
WORKDIR "/src/PartnerPortalCore"
RUN dotnet build "PartnerPortalCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PartnerPortalCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PartnerPortalCore.dll"]
