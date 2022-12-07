class UnbordingContent{
  String image;
  String title;
  String description;

  UnbordingContent({required this.image, required this.title, required this.description});
}

List <UnbordingContent> contents = [

  UnbordingContent(
    image: 'assets/images/tracing.gif', 
    title: 'Tracing', 
    description: "Keep track of nearby devices"
  ),

  UnbordingContent(
    image: 'assets/images/sick.gif', 
    title: 'Symptoms', 
    description: "Check your symtoms easy and quick"
  ),

  UnbordingContent(
    image: 'assets/images/statistics.gif', 
    title: 'Statistics', 
    description: "Get real time Covid-19 cases"
  ),

];