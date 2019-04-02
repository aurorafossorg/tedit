
// main entrypoint
int main(string[] args)
{
	import tedit.app : TeditApplication;
	TeditApplication app = new TeditApplication(args);
	app.start();

	return 0;
}