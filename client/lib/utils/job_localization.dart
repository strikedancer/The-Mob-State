import '../l10n/app_localizations.dart';

/// Localized job titles/descriptions (backend may send English fallbacks).
class JobLocalization {
  JobLocalization._();

  static String name(String jobId, AppLocalizations l10n, {required String fallback}) {
    switch (jobId) {
      case 'newspaper_delivery':
        return l10n.jobNewspaperDeliveryName;
      case 'car_wash':
        return l10n.jobCarWashName;
      case 'grocery_bagger':
        return l10n.jobGroceryBaggerName;
      case 'dishwasher':
        return l10n.jobDishwasherName;
      case 'street_sweeper':
        return l10n.jobStreetSweeperName;
      case 'pizza_delivery':
        return l10n.jobPizzaDeliveryName;
      case 'taxi_driver':
        return l10n.jobTaxiDriverName;
      case 'warehouse_worker':
        return l10n.jobWarehouseWorkerName;
      case 'construction_worker':
        return l10n.jobConstructionWorkerName;
      case 'bartender':
        return l10n.jobBartenderName;
      case 'security_guard':
        return l10n.jobSecurityGuardName;
      case 'truck_driver':
        return l10n.jobTruckDriverName;
      case 'mechanic':
        return l10n.jobMechanicName;
      case 'electrician':
        return l10n.jobElectricianName;
      case 'plumber':
        return l10n.jobPlumberName;
      case 'chef':
        return l10n.jobChefName;
      case 'paramedic':
        return l10n.jobParamedicName;
      case 'programmer':
        return l10n.jobProgrammerName;
      case 'accountant':
        return l10n.jobAccountantName;
      case 'lawyer':
        return l10n.jobLawyerName;
      case 'real_estate_agent':
        return l10n.jobRealEstateAgentName;
      case 'stockbroker':
        return l10n.jobStockbrokerName;
      case 'doctor':
        return l10n.jobDoctorName;
      case 'airline_pilot':
        return l10n.jobAirlinePilotName;
      default:
        return fallback;
    }
  }

  static String description(
    String jobId,
    AppLocalizations l10n, {
    required String fallback,
  }) {
    switch (jobId) {
      case 'newspaper_delivery':
        return l10n.jobNewspaperDeliveryDesc;
      case 'car_wash':
        return l10n.jobCarWashDesc;
      case 'grocery_bagger':
        return l10n.jobGroceryBaggerDesc;
      case 'dishwasher':
        return l10n.jobDishwasherDesc;
      case 'street_sweeper':
        return l10n.jobStreetSweeperDesc;
      case 'pizza_delivery':
        return l10n.jobPizzaDeliveryDesc;
      case 'taxi_driver':
        return l10n.jobTaxiDriverDesc;
      case 'warehouse_worker':
        return l10n.jobWarehouseWorkerDesc;
      case 'construction_worker':
        return l10n.jobConstructionWorkerDesc;
      case 'bartender':
        return l10n.jobBartenderDesc;
      case 'security_guard':
        return l10n.jobSecurityGuardDesc;
      case 'truck_driver':
        return l10n.jobTruckDriverDesc;
      case 'mechanic':
        return l10n.jobMechanicDesc;
      case 'electrician':
        return l10n.jobElectricianDesc;
      case 'plumber':
        return l10n.jobPlumberDesc;
      case 'chef':
        return l10n.jobChefDesc;
      case 'paramedic':
        return l10n.jobParamedicDesc;
      case 'programmer':
        return l10n.jobProgrammerDesc;
      case 'accountant':
        return l10n.jobAccountantDesc;
      case 'lawyer':
        return l10n.jobLawyerDesc;
      case 'real_estate_agent':
        return l10n.jobRealEstateAgentDesc;
      case 'stockbroker':
        return l10n.jobStockbrokerDesc;
      case 'doctor':
        return l10n.jobDoctorDesc;
      case 'airline_pilot':
        return l10n.jobAirlinePilotDesc;
      default:
        return fallback;
    }
  }
}
