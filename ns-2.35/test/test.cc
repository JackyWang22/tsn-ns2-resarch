

#include <stdio.h>
#include <string.h>
#include "agent.h"

class MyAgent : public Agent {
public:
	MyAgent(); //constructor
protected:
	int command (int argc, const char*const* argv);
private:
	double username, userid;
	void TranslateUsername();
	void ShowUserID();

};

// connect Otcl and c++
static class MyAgentClass : public TclClass {
public:
	MyAgentClass(): TclClass("Agent/MYAGENT"){}
	//s
	TclObject* create(int, const char*const*){
		return (new MyAgent());
	}
}class_my_agent;

//shadow object. When TCL object is called. C++ class will reuturn a agent

//implement funciton of the main class
MyAgent::MyAgent():Agent(PT_UDP) {
	bind("Username",&username);
	bind("Userid",&userid);
}
// binding is between Otcl and c++ variable

int MyAgent::command(int argc, const char*const* argv) {
	if (argc == 2){
		if(strcmp(argv[1],"name")==0){
			TranslateUsername();
			return(TCL_OK);
		}
		if(strcmp(argv[1],"id")==0){
			ShowUserID();
			return(TCL_OK);
		}
	}
	return(Agent::command(argc,argv));
}

void MyAgent::TranslateUsername(){
	Tcl& tcl = Tcl::instance();
	tcl.eval("puts \"Message from TranslateUsername Function\" ");
	tcl.evalf("puts \"The Name is %f\" ", username);
}

void MyAgent::ShowUserID(){
	Tcl& tcl = Tcl::instance();
	tcl.eval("puts \"Message from ShowUserID Function\" ");
	tcl.evalf("puts \"The ID is %f\" ",userid);
}