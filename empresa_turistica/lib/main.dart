import 'package:flutter/material.dart';
import 'servicio_turistico.dart';
import 'paquete.dart';
import 'vuelo.dart';
import 'politica_vuelo.dart';
import 'hotel.dart';
import 'politica_hotel.dart';

void main() {
  runApp(const EmpresaTuristicaApp());
}

class EmpresaTuristicaApp extends StatelessWidget {
  const EmpresaTuristicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empresa Turística',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ReservaScreen(),
    );
  }
}

class ReservaScreen extends StatefulWidget {
  const ReservaScreen({super.key});

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  // Paquete raíz según el apunte del profesor
  final Paquete paqueteRaiz = Paquete("Mi Viaje Personalizado");

  // Inventario de servicios previos creados por el sistema
  final List<ServicioTuristico> inventarioDisponible = [
    Vuelo("IB-2024", 120.0, TarifaLowCost()),
    Vuelo("RY-9981", 85.0, TarifaLowCost()),
    Hotel("Granada Palace", 90.0, 2, SoloAlojamiento()),
    Hotel("Meliá Sierra Nevada", 150.0, 4, SoloAlojamiento()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Reservas"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- COLUMNA IZQUIERDA: INVENTARIO ---
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey.shade300, width: 2)),
                    ),
                    child: Column(
                      children: [
                        _buildHeader("Servicios Disponibles", Icons.inventory, Colors.black87),
                        Expanded(
                          child: ListView.builder(
                            itemCount: inventarioDisponible.length,
                            itemBuilder: (context, index) => _buildInventarioCard(inventarioDisponible[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- COLUMNA DERECHA: PAQUETE RAÍZ ---
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader("Tu Paquete Vacacional", Icons.shopping_cart, Colors.blue),
                      Expanded(
                        child: paqueteRaiz.servicios.isEmpty
                            ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "El paquete está vacío.\nAñade algo de la izquierda.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                            : ListView.builder(
                          itemCount: paqueteRaiz.servicios.length,
                          itemBuilder: (context, index) => _buildPaqueteCard(paqueteRaiz.servicios[index]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // PANEL DE PRECIO TOTAL (FIJO ABAJO)
          _buildTotalPanel(),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES DE UI ---

  Widget _buildHeader(String titulo, IconData icono, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: color.withOpacity(0.05),
      child: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: 10),
          Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildInventarioCard(ServicioTuristico servicio) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          servicio is Vuelo ? "Vuelo ${servicio.id}" : "Hotel ${(servicio as Hotel).nombre}",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: servicio is Vuelo ? _buildVueloSelector(servicio) : _buildHotelSelector(servicio as Hotel),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
          tooltip: "Añadir al paquete",
          onPressed: () => setState(() => paqueteRaiz.agregar(servicio)),
        ),
      ),
    );
  }

  Widget _buildPaqueteCard(ServicioTuristico servicio) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(servicio is Vuelo ? Icons.flight_takeoff : Icons.hotel, color: Colors.blue),
        title: Text(
          servicio is Vuelo ? "Vuelo ${servicio.id}" : "Hotel ${(servicio as Hotel).nombre}",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: servicio is Vuelo ? _buildVueloSelector(servicio) : _buildHotelSelector(servicio as Hotel),
        trailing: IconButton(
          icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
          tooltip: "Quitar del paquete",
          onPressed: () {
            setState(() {
              paqueteRaiz.remover(servicio);
            });
          },
        ),
      ),
    );
  }

  // --- SELECTORES DE POLÍTICA (STRATEGY) ---

  Widget _buildVueloSelector(Vuelo vuelo) {
    return DropdownButton<PoliticaVuelo>(
      value: vuelo.politica,
      isExpanded: true,
      style: const TextStyle(fontSize: 12, color: Colors.black),
      onChanged: (val) => setState(() => vuelo.politica = val!),
      items: [
        DropdownMenuItem(value: TarifaLowCost(), child: const Text("LowCost (+15€)")),
        DropdownMenuItem(value: TarifaBusiness(), child: const Text("Business (x2.5)")),
      ],
    );
  }

  Widget _buildHotelSelector(Hotel hotel) {
    return DropdownButton<PoliticaHotel>(
      value: hotel.politica,
      isExpanded: true,
      style: const TextStyle(fontSize: 12, color: Colors.black),
      onChanged: (val) => setState(() => hotel.politica = val!),
      items: [
        DropdownMenuItem(value: SoloAlojamiento(), child: const Text("Solo Alojamiento")),
        DropdownMenuItem(value: TodoIncluido(), child: const Text("Todo Incluido (+40€/día)")),
      ],
    );
  }

  Widget _buildTotalPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("PRECIO TOTAL DEL PAQUETE:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text("${paqueteRaiz.getPrecio().toStringAsFixed(2)}€",
                style: const TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}