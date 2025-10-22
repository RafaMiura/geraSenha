class Routes {
static const String intro = '/';
static const String login = 'login';
static const String home = 'home';



static Route<dynamic> generateRoute(RouteSettings
settings) {
 switch (settings.name) {
 case home:
 return MaterialPageRoute(builder: (_) =>
HomeScreen());
 case select:
 return MaterialPageRoute(builder: (_) =>
SelectScreen());
 default:
 return MaterialPageRoute(
 builder:
 (_) =>
 Scaffold(body: Center(child: Text('Rota
não encontrada!'))),
 );
 }
 }
}