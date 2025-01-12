import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:regrip/homepage.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late DatabaseReference dbRef;

  final name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final bloodGroup = TextEditingController();
  final medicalConditions = TextEditingController();
  final emergencyContactName = TextEditingController();
  final emergencyContactPhone = TextEditingController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('User');
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _showSummary();
      }
    }
  }

  void _showSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Summary'),
        content: Text(
          'Name: ${name.text}\n'
              'Email: ${email.text}\n'
              'Phone: ${phoneNumber.text}\n'
              'Blood Group: ${bloodGroup.text}\n'
              'Medical Conditions: ${medicalConditions.text.isNotEmpty ? medicalConditions.text : "None"}\n'
              'Emergency Contact: ${emergencyContactName.text} (${emergencyContactPhone.text})',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Map<String, String> user = {
                'Name': name.text,
                'Email': email.text,
                'PhoneNumber': phoneNumber.text,
                'BloodGroup': bloodGroup.text,
                'MedicalConditions': medicalConditions.text,
                'EmergencyContactName': emergencyContactName.text,
                'EmergencyContactPhone': emergencyContactPhone.text,
                'timestamp': DateTime.now().toIso8601String(),
              };
              dbRef.push().set(user);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const homepage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form Submitted Successfully!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Registration',style: TextStyle(color:Colors.deepPurple.shade700),)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _currentStep < 2
          ? ElevatedButton(
        onPressed: _nextStep,
        child: Text('Next',style: TextStyle(fontSize: 25,height: 3,fontWeight: FontWeight.bold,color: Colors.deepPurple.shade900),),
      )
          : ElevatedButton(
        onPressed: _showSummary,
        child: Text('Show Summary',style: TextStyle(fontSize: 25,height: 3,fontWeight: FontWeight.bold,color: Colors.deepPurple.shade900)),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
         const SizedBox(height: 20,),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Name',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          )
              ,),
            validator: (value) => value!.isEmpty ? 'Name is required' : null,
          ),
        const SizedBox(height: 20,),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(labelText: 'Email',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),),
            validator: (value) => value!.isEmpty || !value.contains('@')
                ? 'Valid email required'
                : null,
          ),
         const SizedBox(height: 20,),
          TextFormField(
            controller: phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone Number',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),),
            validator: (value) =>
            value!.length != 10 ? 'Phone number must be 10 digits' : null,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
     padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
         const  SizedBox(height: 20,),
          TextFormField(
            controller: bloodGroup,
            decoration: const InputDecoration(labelText: 'Blood Group',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),),
            validator: (value) => value!.isEmpty ? 'Blood group is required' : null,
          ),
         const  SizedBox(height: 20,),
          TextFormField(
            controller: medicalConditions,
            decoration: const InputDecoration(labelText: 'Medical Conditions',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          TextFormField(
            controller: emergencyContactName,
            decoration: const InputDecoration(labelText: 'Emergency Contact Name',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),),
            validator: (value) => value!.isEmpty
                ? 'Emergency contact name is required'
                : null,
          ),
          const SizedBox(height: 20,),
          TextFormField(
            controller: emergencyContactPhone,
            decoration: const InputDecoration(labelText: 'Emergency Contact Phone',
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 143, 123, 123),width: 1,),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple,width: 2,),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
            validator: (value) =>
            value!.length != 10 ? 'Phone number must be 10 digits' : null,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
