import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/product_entity.dart';

class ProductFormModal extends StatefulWidget {
  final ProductEntity? producto;
  final Function(Map<String, String> fields, File? imageFile) onSave;

  const ProductFormModal({super.key, this.producto, required this.onSave});

  @override
  State<ProductFormModal> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<ProductFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _precioCtrl;
  late TextEditingController _descCtrl;
  String _estado = 'Disponible';
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.producto?.nombre ?? '');
    _precioCtrl = TextEditingController(
      text: widget.producto?.precio.toString() ?? '',
    );
    _descCtrl = TextEditingController(text: widget.producto?.descripcion ?? '');
    _estado = widget.producto?.estado ?? 'Disponible';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final path = pickedFile.path;
      final ext = path.contains('.') ? path.split('.').last.toLowerCase() : '';
      const allowed = ['jpg', 'jpeg', 'png', 'webp', 'gif'];
      if (ext.isEmpty || !allowed.contains(ext)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formato de imagen no válido. Use JPG, PNG, WEBP o GIF.')),
          );
        }
        return;
      }
      setState(() => _selectedImage = File(path));
    }
  }

  Future<File> _convertImageToJpg(File input) async {
    final bytes = await input.readAsBytes();
    final image = img_lib.decodeImage(bytes);
    if (image == null) throw Exception('No se pudo decodificar la imagen');
    final jpg = img_lib.encodeJpg(image, quality: 85);
    final tempDir = await getTemporaryDirectory();
    final outPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outFile = File(outPath);
    await outFile.writeAsBytes(jpg);
    return outFile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.producto == null ? 'Nuevo Producto' : 'Editar Producto',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: _precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                items: const [
                  DropdownMenuItem(
                    value: 'Disponible',
                    child: Text('Disponible'),
                  ),
                  DropdownMenuItem(value: 'Agotado', child: Text('Agotado')),
                ],
                onChanged: (v) => setState(() => _estado = v!),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Subir Imagen'),
                onPressed: _pickImage,
              ),
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 80),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // validate selected image extension before sending
                        if (_selectedImage != null) {
                          final path = _selectedImage!.path;
                          final ext = path.contains('.') ? path.split('.').last.toLowerCase() : '';
                          const allowed = ['jpg', 'jpeg', 'png', 'webp', 'gif'];
                          if (ext.isEmpty || !allowed.contains(ext)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Formato de imagen no válido. Use JPG, PNG, WEBP o GIF.')),
                            );
                            return;
                          }
                        }

                        File? fileToSend = _selectedImage;
                        if (_selectedImage != null) {
                          try {
                            fileToSend = await _convertImageToJpg(_selectedImage!);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error procesando la imagen. Intente otra.')),
                            );
                            return;
                          }
                        }

                        widget.onSave({
                          'nombre': _nombreCtrl.text,
                          'precio': _precioCtrl.text,
                          'estado': _estado,
                          'descripcion': _descCtrl.text,
                          'id_categoria':
                              widget.producto?.idCategoria.toString() ?? '1',
                          'id_proveedor':
                              widget.producto?.idProveedor.toString() ?? '1',
                        }, fileToSend);
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
