import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/job.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/event_renderer.dart';
import '../services/jail_service.dart';
import '../widgets/jail_screen.dart';
import '../widgets/cooldown_overlay.dart';
import '../widgets/job_card.dart';
import '../widgets/education_requirements_dialog.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();
  List<Job> _jobs = [];
  List<Map<String, dynamic>> _lockedJobs = [];
  bool _isLoading = true;
  bool _isWorking = false;
  String? _error;
  int? _jailTime; // null = not jailed, >0 = minutes remaining
  int? _cooldownSeconds; // null = not on cooldown, >0 = seconds remaining

  @override
  void initState() {
    super.initState();
    _checkJailStatusAndLoadJobs();
  }

  Future<void> _checkJailStatusAndLoadJobs() async {
    // First check if player is in jail
    final jailTime = await _jailService.checkJailStatus();

    if (jailTime > 0) {
      // Refresh player data to get current wanted level for bail button
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.refreshPlayer();

      setState(() {
        _jailTime = jailTime;
        _isLoading = false;
      });
      return; // Don't load jobs if jailed
    }

    // Check for active cooldown by attempting to load jobs
    try {
      final response = await _apiClient.get('/jobs');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for cooldown in response
        if (data['cooldown'] != null && data['cooldown'] is Map) {
          final cooldownData = data['cooldown'] as Map<String, dynamic>;
          if (cooldownData['remainingSeconds'] != null) {
            setState(() {
              _cooldownSeconds = cooldownData['remainingSeconds'] as int;
              _isLoading = false;
            });
            return; // Don't load jobs if on cooldown
          }
        }

        // No cooldown, load education-aware jobs payload
        await _loadJobs();
        return;
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingJobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.connectionError(e.toString());
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/jobs/available');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jobsJson = (data['jobs'] as List? ?? const []);
        final lockedJobsJson = (data['lockedJobs'] as List? ?? const []);
        setState(() {
          _jobs = jobsJson.map((j) => Job.fromJson(j)).toList();
          _lockedJobs = lockedJobsJson
              .whereType<Map>()
              .map((entry) => entry.cast<String, dynamic>())
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingJobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.connectionError(e.toString());
        _isLoading = false;
      });
    }
  }

  Future<void> _showLockedJobDetails(Map<String, dynamic> job) async {
    final l10n = AppLocalizations.of(context)!;
    await EducationRequirementsDialog.show(
      context,
      title: '🔒 ${job['name'] ?? l10n.jobs}',
      subtitle: job['description']?.toString(),
      missingRequirements: (job['educationMissing'] as List?) ?? const [],
    );
  }

  Widget _buildLockedJobTile(Map<String, dynamic> job) {
    final l10n = AppLocalizations.of(context)!;
    final imageAsset = 'assets/images/jobs/${job['id']}_job.png';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFFFFC107).withOpacity(0.75),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showLockedJobDetails(job),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      color: Colors.grey[850],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: WebAssetHelper.image(
                        imageAsset,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[850],
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.work_outline,
                              color: Colors.white54,
                              size: 26,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFFFFC107),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (job['name'] ?? l10n.jobs).toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (job['description'] ?? '').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 9, color: Colors.grey[300]),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 12,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.achievementLocked,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFFC107),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doJob(Job job) async {
    setState(() {
      _isWorking = true;
      _error = null;
    });

    try {
      final response = await _apiClient.post('/jobs/${job.id}/work', {});

      final data = jsonDecode(response.body);
      final eventKey = data['event'] as String;
      final params = (data['params'] as Map<String, dynamic>?) ?? {};

      // Check if error.cooldown - show cooldown overlay
      if (eventKey == 'error.cooldown') {
        final remainingSeconds = params['remainingSeconds'] as int? ?? 0;

        setState(() {
          _isWorking = false;
          _cooldownSeconds = remainingSeconds;
        });
        return;
      }

      // Check if error.jailed - handle specially
      if (eventKey == 'error.jailed') {
        final remainingTime = params['remainingTime'] as int? ?? 0;
        final l10n = AppLocalizations.of(context)!;
        final eventRenderer = EventRenderer(l10n);
        final message = eventRenderer.renderEvent(eventKey, params);

        setState(() {
          _isWorking = false;
          _jailTime = remainingTime; // Show jail screen
        });

        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: remainingTime > 60 ? 10 : 5),
            ),
          );
        }
        return;
      }

      final l10n = AppLocalizations.of(context)!;
      final eventRenderer = EventRenderer(l10n);
      final message = eventRenderer.renderEvent(eventKey, params);

      setState(() {
        _isWorking = false;
      });

      // Check if cooldown info is in response
      int? cooldownSeconds;
      if (data.containsKey('cooldown') && data['cooldown'] != null) {
        final cooldownData = data['cooldown'] as Map<String, dynamic>;
        if (cooldownData['remainingSeconds'] != null) {
          cooldownSeconds = cooldownData['remainingSeconds'] as int;
          setState(() {
            _cooldownSeconds = cooldownSeconds;
          });
        }
      }

      // Update player stats from response
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (data.containsKey('player')) {
          final playerData = data['player'] as Map<String, dynamic>;
          authProvider.updatePlayerStats(
            money: playerData['money'] as int?,
            xp: playerData['xp'] as int?,
            rank: playerData['rank'] as int?,
          );
        } else {
          // Fallback: refresh full player data
          await authProvider.refreshPlayer();
        }

        // Keep cooldown UI embedded in this screen (no full-page route)
        if (cooldownSeconds != null && cooldownSeconds > 0) {
          showTopRightFromSnackBar(context,
            SnackBar(
              content: Text(message),
              backgroundColor: eventKey.contains('completed')
                  ? Colors.green
                  : Colors.red,
            ),
          );
        } else {
          // No cooldown, just show snackbar
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(message),
              backgroundColor: eventKey.contains('success')
                  ? Colors.green
                  : Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.error(e.toString());
        _isWorking = false;
      });
    }
  }

  // Unused - kept for potential future use
  /*
  String _localizedJobName(Job job, AppLocalizations l10n) {
    switch (job.id) {
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
        return job.name;
    }
  }
  */

  // Unused - kept for potential future use
  /*
  String _localizedJobDescription(Job job, AppLocalizations l10n) {
    switch (job.id) {
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
        return job.description ?? '';
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobs)),
      body: _cooldownSeconds != null && _cooldownSeconds! > 0
          ? CooldownOverlay(
              actionType: 'job',
              remainingSeconds: _cooldownSeconds!,
              embedded: true,
              onExpired: () {
                setState(() {
                  _cooldownSeconds = null;
                });
                _checkJailStatusAndLoadJobs();
              },
            )
          : _jailTime != null && _jailTime! > 0
          ? JailOverlay(
              remainingSeconds: _jailTime!,
              wantedLevel: player?.wantedLevel,
              onReleased: () {
                setState(() {
                  _jailTime = null;
                });
                _loadJobs();
              },
            )
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 480
                        ? 2
                        : MediaQuery.of(context).size.width < 900
                        ? 3
                        : 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: _jobs.length,
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    final canWork = (player?.rank ?? 1) >= job.requiredRank;

                    return JobCard(
                      job: job,
                      canWork: canWork,
                      isWorking: _isWorking,
                      onTap: () => _doJob(job),
                    );
                  },
                ),
                if (_lockedJobs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.educationLockedJobsSectionTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 480
                          ? 2
                          : MediaQuery.of(context).size.width < 900
                          ? 3
                          : 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: _lockedJobs.length,
                    itemBuilder: (context, index) {
                      return _buildLockedJobTile(_lockedJobs[index]);
                    },
                  ),
                ],
              ],
            ),
    );
  }
}
