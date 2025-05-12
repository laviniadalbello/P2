import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'criarevento.dart'; // Assuming CreateEventScreen is in the same directory or path is configured

// --- Cores (mantidas do projeto) ---
const Color kDarkPrimaryBg = Color(0xFF1A1A2E);
const Color kDarkSurface = Color(0xFF16213E);
const Color kDarkElementBg = Color(0xFF202A44);
const Color kAccentPurple = Color(0xFF7F5AF0);
const Color kAccentSecondary = Color(0xFF2CB67D);
const Color kDarkTextPrimary = Color(0xFFFFFFFF);
const Color kDarkTextSecondary = Color(0xFFA0AEC0);
const Color kDarkBorder = Color(0xFF2D3748);
// --- Fim das Cores ---

// Enum for Event Filter
enum EventFilter { all, completed, inProgress, upcoming }

// Enum for Event Status
enum EventStatus { upcoming, inProgress, completed, cancelled }

class Event {
  final String id;
  final String name;
  final String? description;
  final DateTime startDate;
  final TimeOfDay startTime;
  final DateTime? endDate;
  final TimeOfDay? endTime;
  final String? location;
  final Color eventColor;
  final List<Map<String, String>>? participants; // e.g., [{'name': 'John', 'email': 'john@example.com'}]
  final List<String>? attachments; // e.g., ['file1.pdf', 'image.png']
  final String? notes;
  EventStatus status;

  Event({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.startTime,
    this.endDate,
    this.endTime,
    this.location,
    required this.eventColor,
    this.participants,
    this.attachments,
    this.notes,
    this.status = EventStatus.upcoming,
  });

  String get formattedStartDate => DateFormat('dd/MM/yyyy').format(startDate);
  String formattedStartTime(BuildContext context) => startTime.format(context);
  String? get formattedEndDate => endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : null;
  String? formattedEndTime(BuildContext context) => endTime?.format(context);
}

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  DateTime _selectedDate = DateTime.now();
  EventFilter _currentFilter = EventFilter.all;
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadSampleEvents(); // Load initial data
    _filterEvents(); // Apply initial filter
    // Initialize localization for date formatting (if not done globally)
    // This might be needed if 'pt_BR' is not the default locale.
    // Ensure `flutter_localizations` is in pubspec.yaml and main.dart is configured.
    // For this screen, `DateFormat` will use the default locale unless specified.
  }

  void _loadSampleEvents() {
    _allEvents = [
      Event(
        id: '1',
        name: 'Reunião de Equipe Semanal',
        description: 'Discussão sobre o progresso da sprint atual e planejamento da próxima. Rever os KPIs e definir metas para a semana.',
        startDate: DateTime.now(), 
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endDate: DateTime.now(), 
        endTime: const TimeOfDay(hour: 11, minute: 0),
        location: 'Sala de Conferência A / Online (Zoom)',
        eventColor: kAccentPurple,
        participants: [{'name': 'Alice', 'email': 'alice@example.com'}, {'name': 'Bob', 'email': 'bob@example.com'}],
        attachments: ['sprint_review.pdf'],
        notes: 'Lembrar de preparar a pauta com antecedência.',
        status: EventStatus.upcoming,
      ),
      Event(
        id: '2',
        name: 'Workshop de Flutter Avançado',
        description: 'Workshop prático sobre gerenciamento de estado e animações complexas em Flutter.',
        startDate: DateTime.now().add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endDate: DateTime.now().add(const Duration(days: 1)),
        endTime: const TimeOfDay(hour: 17, minute: 30),
        location: 'Auditório Principal - Bloco Tech',
        eventColor: kAccentSecondary,
        participants: [{'name': 'Carlos', 'email': 'carlos@example.com'}, {'name': 'Diana', 'email': 'diana@example.com'}],
        status: EventStatus.upcoming,
      ),
      Event(
        id: '3',
        name: 'Apresentação Cliente X Final',
        description: 'Apresentação da proposta final e demonstração do protótipo para o Cliente X.',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 15, minute: 30),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
        endTime: const TimeOfDay(hour: 16, minute: 30),
        location: 'Escritório do Cliente X, Sala 3B',
        eventColor: Colors.orangeAccent.shade200,
        participants: [{'name': 'Cliente X Rep', 'email': 'rep@clientx.com'}],
        attachments: ['proposta_final_cliente_x.pptx', 'prototipo_ux.zip'],
        status: EventStatus.completed,
      ),
      Event(
        id: '4',
        name: 'Evento de Lançamento Produto Y',
        description: 'Grande evento de lançamento do novo Produto Y, com palestras, networking e demonstrações ao vivo.',
        startDate: DateTime.now(), // Evento em andamento hoje
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endDate: DateTime.now(),
        endTime: const TimeOfDay(hour: 18, minute: 0),
        location: 'Centro de Convenções Metropolitano',
        eventColor: Colors.pinkAccent.shade200,
        status: EventStatus.inProgress, 
      ),
       Event(
        id: '5',
        name: 'Happy Hour da Empresa',
        description: 'Confraternização mensal da equipe.',
        startDate: DateTime.now().add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 18, minute: 0),
        location: 'Bar Local Favorito',
        eventColor: Colors.teal.shade300,
        status: EventStatus.upcoming,
      ),
    ];
  }

  void _filterEvents() {
    List<Event> eventsForSelectedDate = _allEvents.where((event) {
      return event.startDate.year == _selectedDate.year &&
             event.startDate.month == _selectedDate.month &&
             event.startDate.day == _selectedDate.day;
    }).toList();

    switch (_currentFilter) {
      case EventFilter.all:
        _filteredEvents = eventsForSelectedDate;
        break;
      case EventFilter.completed:
        _filteredEvents = eventsForSelectedDate.where((event) => event.status == EventStatus.completed).toList();
        break;
      case EventFilter.inProgress:
        _filteredEvents = eventsForSelectedDate.where((event) => event.status == EventStatus.inProgress).toList();
        break;
      case EventFilter.upcoming:
        _filteredEvents = eventsForSelectedDate.where((event) => event.status == EventStatus.upcoming).toList();
        break;
    }
    // Sort events by start time
    _filteredEvents.sort((a, b) {
      final aDateTime = DateTime(a.startDate.year, a.startDate.month, a.startDate.day, a.startTime.hour, a.startTime.minute);
      final bDateTime = DateTime(b.startDate.year, b.startDate.month, b.startDate.day, b.startTime.hour, b.startTime.minute);
      return aDateTime.compareTo(bDateTime);
    });

    setState(() {});
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _filterEvents();
    });
  }

  void _showEventDetailsPopup(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kDarkElementBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 10,
                height: 24, 
                decoration: BoxDecoration(
                  color: event.eventColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.only(right: 10),
              ),
              Expanded(child: Text(event.name, style: const TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.bold))),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (event.description != null && event.description!.isNotEmpty)
                  _buildDetailRow(Icons.description_outlined, 'Descrição:', event.description!),
                _buildDetailRow(Icons.calendar_today_outlined, 'Data Início:', event.formattedStartDate),
                _buildDetailRow(Icons.access_time_outlined, 'Hora Início:', event.formattedStartTime(context)),
                if (event.formattedEndDate != null)
                  _buildDetailRow(Icons.calendar_today_outlined, 'Data Término:', event.formattedEndDate!),
                if (event.endTime != null)
                  _buildDetailRow(Icons.access_time_outlined, 'Hora Término:', event.formattedEndTime(context)!),
                if (event.location != null && event.location!.isNotEmpty)
                  _buildDetailRow(Icons.location_on_outlined, 'Local:', event.location!),
                _buildDetailRow(Icons.label_important_outline, 'Status:', _getEventStatusText(event.status), color: _getEventStatusColor(event.status)),
                if (event.participants != null && event.participants!.isNotEmpty)
                  _buildDetailSectionTitle('Participantes:'),
                if (event.participants != null)
                  ...event.participants!.map((p) => Text('  • ${p['name']} (${p['email']})', style: const TextStyle(color: kDarkTextSecondary, fontSize: 14))),
                if (event.attachments != null && event.attachments!.isNotEmpty)
                  _buildDetailSectionTitle('Anexos:'),
                if (event.attachments != null)
                  ...event.attachments!.map((a) => Text('  • $a', style: const TextStyle(color: kDarkTextSecondary, fontSize: 14))),
                if (event.notes != null && event.notes!.isNotEmpty)
                  _buildDetailRow(Icons.note_alt_outlined, 'Notas:', event.notes!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Editar', style: TextStyle(color: kAccentPurple)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _editEvent(event);
              },
            ),
            TextButton(
              child: const Text('Fechar', style: TextStyle(color: kDarkTextSecondary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kDarkTextSecondary, size: 18),
          const SizedBox(width: 8),
          Text('$label ', style: const TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(child: Text(value, style: TextStyle(color: color ?? kDarkTextSecondary, fontSize: 14))),
        ],
      ),
    );
  }
   Widget _buildDetailSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
      child: Text(title, style: const TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  String _getEventStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'Próximo';
      case EventStatus.inProgress:
        return 'Em Andamento';
      case EventStatus.completed:
        return 'Concluído';
      case EventStatus.cancelled:
        return 'Cancelado';
      // No default needed if all enum cases are handled.
    }
  }  Color _getEventStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return Colors.blue.shade300;
      case EventStatus.inProgress:
        return Colors.green.shade400;
      case EventStatus.completed:
        return kDarkTextSecondary;
      case EventStatus.cancelled:
        return Colors.red.shade300;
      // No default needed if all enum cases are handled.
    }
  }

  void _editEvent(Event event) {
    // Navigate to CreateEventScreen for editing.
    // CreateEventScreen needs to be adapted to accept an optional Event object
    // and pre-fill its fields for editing.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventPage(eventToEdit: event), // Pass the event here
      ),
    ).then((updatedEvent) {
      if (updatedEvent != null && updatedEvent is Event) {
        // Find the event in _allEvents and update it
        int index = _allEvents.indexWhere((e) => e.id == updatedEvent.id);
        if (index != -1) {
          setState(() {
            _allEvents[index] = updatedEvent;
            _filterEvents(); // Re-filter and update UI
          });
        }
      } else if (updatedEvent == true) { // Generic refresh signal if specific event not returned
         _filterEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryBg,
      appBar: AppBar(
        backgroundColor: kDarkSurface,
        elevation: 0.5,
        title: const Text('Meus Eventos', style: TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<EventFilter>(
            icon: const Icon(Icons.more_vert, color: kDarkTextPrimary),
            color: kDarkElementBg,
            onSelected: (EventFilter result) {
              setState(() {
                _currentFilter = result;
                _filterEvents();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<EventFilter>>[
              const PopupMenuItem<EventFilter>(
                value: EventFilter.all,
                child: Text('Todos Eventos do Dia', style: TextStyle(color: kDarkTextPrimary)),
              ),
              const PopupMenuItem<EventFilter>(
                value: EventFilter.upcoming,
                child: Text('Próximos no Dia', style: TextStyle(color: kDarkTextPrimary)),
              ),
              const PopupMenuItem<EventFilter>(
                value: EventFilter.inProgress,
                child: Text('Em Andamento no Dia', style: TextStyle(color: kDarkTextPrimary)),
              ),
              const PopupMenuItem<EventFilter>(
                value: EventFilter.completed,
                child: Text('Concluídos no Dia', style: TextStyle(color: kDarkTextPrimary)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _currentFilter == EventFilter.all 
                          ? 'Nenhum evento para ${DateFormat('dd/MM/yyyy').format(_selectedDate)}.' 
                          : 'Nenhum evento ${_getFilterTextForEmptyState()} para ${DateFormat('dd/MM/yyyy').format(_selectedDate)}.',
                        style: const TextStyle(color: kDarkTextSecondary, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEventPage()),
            ).then((newEventAdded) {
                 // If CreateEventScreen returns true or an event, refresh the list
                if (newEventAdded != null) { // Could be a boolean or the new event itself
                    _loadSampleEvents(); // Reload or fetch new data
                    _filterEvents();
                }
            });
        },
        backgroundColor: kAccentPurple,
        child: const Icon(Icons.add, color: kDarkTextPrimary),
      ),
    );
  }

  String _getFilterTextForEmptyState(){
    switch(_currentFilter){
      case EventFilter.upcoming: return 'próximo';
      case EventFilter.inProgress: return 'em andamento';
      case EventFilter.completed: return 'concluído';
      default: return '';
    }
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: kDarkSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: kDarkTextPrimary),
            onPressed: () {
              _onDateSelected(_selectedDate.subtract(const Duration(days: 1)));
            },
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(DateTime.now().year - 5), // Allow 5 years back
                lastDate: DateTime(DateTime.now().year + 5), // Allow 5 years forward
                locale: const Locale('pt', 'BR'), // Set locale for DatePicker
                 builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: kAccentPurple,
                          onPrimary: kDarkTextPrimary,
                          surface: kDarkSurface,
                          onSurface: kDarkTextPrimary,
                        ),
                        dialogBackgroundColor: kDarkElementBg,
                      ),
                      child: child!,
                    );
                  }
              );
              if (picked != null && picked != _selectedDate) {
                _onDateSelected(picked);
              }
            },
            child: Text(
              DateFormat('EEE, dd MMM yyyy', 'pt_BR').format(_selectedDate),
              style: const TextStyle(color: kDarkTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: kDarkTextPrimary),
            onPressed: () {
              _onDateSelected(_selectedDate.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    String timeRange = event.formattedStartTime(context);
    if (event.endTime != null) {
      timeRange += ' - ${event.formattedEndTime(context)}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: kDarkElementBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showEventDetailsPopup(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 70, 
                decoration: BoxDecoration(
                  color: event.eventColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(color: kDarkTextPrimary, fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled_rounded, color: kDarkTextSecondary.withOpacity(0.8), size: 16),
                        const SizedBox(width: 6),
                        Text(timeRange, style: TextStyle(color: kDarkTextSecondary.withOpacity(0.8), fontSize: 13)),
                      ],
                    ),
                    if (event.location != null && event.location!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: kDarkTextSecondary.withOpacity(0.8), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.location!,
                                style: TextStyle(color: kDarkTextSecondary.withOpacity(0.8), fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                     Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(_getEventStatusText(event.status), 
                                    style: TextStyle(color: _getEventStatusColor(event.status), 
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: kDarkTextSecondary),
                color: kDarkSurface,
                onSelected: (String value) {
                  if (value == 'view') {
                    _showEventDetailsPopup(event);
                  } else if (value == 'edit') {
                    _editEvent(event);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'view',
                    child: Row(children: [Icon(Icons.visibility_outlined, color: kDarkTextSecondary, size: 20), SizedBox(width: 8), Text('Visualizar', style: TextStyle(color: kDarkTextPrimary))]),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(children: [Icon(Icons.edit_outlined, color: kDarkTextSecondary, size: 20), SizedBox(width: 8), Text('Editar', style: TextStyle(color: kDarkTextPrimary))]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
NOTE FOR CreateEventScreen.dart:
To enable editing, CreateEventScreen should be modified to:
1. Accept an optional `Event? eventToEdit` parameter in its constructor.
2. In its `initState`, if `eventToEdit` is not null, populate the TextEditingControllers 
   and other state variables (_selectedEventColor, _participants, _attachments) with 
   the data from `eventToEdit`.
3. The submit function should differentiate between creating a new event and updating an existing one.
   When updating, it might pop with the updated Event object or a success indicator.

Example modification in CreateEventScreen:

```dart
class CreateEventScreen extends StatefulWidget {
  final Event? eventToEdit; // Add this

  const CreateEventScreen({super.key, this.eventToEdit}); // Modify constructor

  // ... rest of the class
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // ... existing controllers and variables

  @override
  void initState() {
    super.initState();
    // ... existing initState logic

    if (widget.eventToEdit != null) {
      final event = widget.eventToEdit!;
      _eventNameController.text = event.name;
      _eventDescriptionController.text = event.description ?? '';
      _eventStartDateController.text = DateFormat('dd/MM/yyyy').format(event.startDate);
      _eventStartTimeController.text = event.startTime.format(context); // Might need context earlier or pass formatted string
      _eventEndDateController.text = event.endDate != null ? DateFormat('dd/MM/yyyy').format(event.endDate!) : '';
      _eventEndTimeController.text = event.endTime != null ? event.endTime!.format(context) : ''; // Same as above for context
      _eventLocationController.text = event.location ?? '';
      _selectedEventColor = event.eventColor;
      _participants = List<Map<String, String>>.from(event.participants ?? []);
      _attachments = List<String>.from(event.attachments ?? []);
      _eventNotesController.text = event.notes ?? '';
      // Note: TimeOfDay.format(context) needs BuildContext. This might require a different approach for pre-filling,
      // or doing it after the first build if context is not available in initState directly for formatting.
      // A common practice is to store TimeOfDay objects and format them in the build method or when controllers are built.
      // For simplicity here, assuming you can get formatted strings or handle it.
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ... gather data from controllers ...
      Event eventData = Event(
        id: widget.eventToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Generate new ID or use existing
        name: _eventNameController.text,
        // ... other fields
        eventColor: _selectedEventColor,
        status: widget.eventToEdit?.status ?? EventStatus.upcoming, // Preserve status or set default
      );

      if (widget.eventToEdit != null) {
        // Update logic
        print("Evento Atualizado: ${eventData.name}");
        Navigator.pop(context, eventData); // Return updated event
      } else {
        // Create new logic
        print("Novo Evento Criado: ${eventData.name}");
        Navigator.pop(context, eventData); // Return new event or true for success
      }
      // ... SnackBar ...
    }
  }
}
```
*/

