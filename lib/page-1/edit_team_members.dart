import 'package:flutter/material.dart';

class TeamMember {
  final String name;
  final String email;
  final String role;
  final String profilePictureUrl; // You can use the URL or File/Image for profile picture

  TeamMember({
    required this.name,
    required this.email,
    required this.role,
    required this.profilePictureUrl,
  });
}

class EditTeamMembersPage extends StatelessWidget {
  final List<TeamMember> teamMembers; // List of team members

  EditTeamMembersPage({required this.teamMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Team Members'),
      ),
      body: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          return buildTeamMemberContainer(context, teamMembers[index]);
        },
      ),
    );
  }

  Widget buildTeamMemberContainer(BuildContext context, TeamMember member) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(member.profilePictureUrl), // Use member.profilePictureUrl for profile picture
          ),
          SizedBox(height: 10.0),
          Text(
            'Name: ${member.name}',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(
            'Email: ${member.email}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 5.0),
          Text(
            'Role: ${member.role}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              // Implement edit functionality
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }
}
