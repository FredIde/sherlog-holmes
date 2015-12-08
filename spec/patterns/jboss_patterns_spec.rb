require 'spec_helper'

describe 'JBoss Patterns' do

  describe '#parse' do

    let(:info_line) { '18:50:42,129 INFO  [org.jboss.modules] (main) JBoss Modules version 1.3.6.Final-redhat-1' }
    let(:info_multiline) do
      <<END.chomp
18:51:04,222 INFO  [org.jboss.ws.cxf.metadata] (MSC service thread 1-2) JBWS024061: Adding service endpoint metadata: id=tools.devnull.logspitter.LogSpitterService
 address=http://localhost:8080/logspitter/LogSpitterService
 implementor=tools.devnull.logspitter.LogSpitterService
 serviceName={http://logspitter.devnull.tools/}LogSpitterServiceService
 portName={http://logspitter.devnull.tools/}LogSpitterServicePort
 annotationWsdlLocation=null
 wsdlLocationOverride=null
 mtomEnabled=false
 publishedEndpointUrl=http://localhost:8080/logspitter/LogSpitterService
 invoker=org.jboss.wsf.stack.cxf.JBossWSInvoker
 properties=[org.jboss.as.webservices.metadata.modelComponentViewName -> service jboss.deployment.unit."logspitter.war".component."tools.devnull.logspitter.LogSpitterService".VIEW."tools.devnull.logspitter.LogSpitterService"]
END
    end
    let(:error_stacktrace) do
      <<END.chomp
18:53:20,034 ERROR [tools.devnull.logspitter] (default-workqueue-1) Something wrong happened: java.lang.NullPointerException: Something wrong happened
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method) [rt.jar:1.8.0_60]
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62) [rt.jar:1.8.0_60]
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45) [rt.jar:1.8.0_60]
	at java.lang.reflect.Constructor.newInstance(Constructor.java:422) [rt.jar:1.8.0_60]
	at tools.devnull.logspitter.impl.JavassistExceptionCreator.createException(JavassistExceptionCreator.java:82) [classes:]
	at tools.devnull.logspitter.impl.JavassistExceptionCreator.create(JavassistExceptionCreator.java:58) [classes:]
	at tools.devnull.logspitter.impl.SpitterMessageConfigImpl.thrownBy(SpitterMessageConfigImpl.java:56) [classes:]
	at tools.devnull.logspitter.LogSpitterService.spit(LogSpitterService.java:81) [classes:]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) [rt.jar:1.8.0_60]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) [rt.jar:1.8.0_60]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) [rt.jar:1.8.0_60]
	at java.lang.reflect.Method.invoke(Method.java:497) [rt.jar:1.8.0_60]
Caused by: java.lang.NullPointerException
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method) [rt.jar:1.8.0_60]
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62) [rt.jar:1.8.0_60]
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45) [rt.jar:1.8.0_60]
	at java.lang.reflect.Constructor.newInstance(Constructor.java:422) [rt.jar:1.8.0_60]
	at tools.devnull.logspitter.impl.JavassistExceptionCreator.createException(JavassistExceptionCreator.java:82) [classes:]
	at tools.devnull.logspitter.impl.JavassistExceptionCreator.create(JavassistExceptionCreator.java:58) [classes:]
	at tools.devnull.logspitter.impl.SpitterMessageConfigImpl.thrownBy(SpitterMessageConfigImpl.java:56) [classes:]
	at tools.devnull.logspitter.LogSpitterService.spit(LogSpitterService.java:81) [classes:]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) [rt.jar:1.8.0_60]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) [rt.jar:1.8.0_60]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) [rt.jar:1.8.0_60]
	at java.lang.reflect.Method.invoke(Method.java:497) [rt.jar:1.8.0_60]
	... 152 more
END
    end

    before(:each) do
      @filter = double Filter
      allow(@filter).to receive(:accept?).and_return(true)

      @parser = Sherlog::parser :jboss
      @parser.filter @filter
      @result = @parser.collect
    end

    it 'should parse the lines correctly' do
      @parser.parse [info_line, info_multiline, error_stacktrace].join($/)
      expect(@result.entries[0].level).to eq('INFO')
      expect(@result.entries[1].level).to eq('INFO')
      expect(@result.entries[2].level).to eq('ERROR')
      expect(@result.entries[2].exception?).to be_truthy
    end

    it 'should parse exceptions correctly' do
      @parser.parse error_stacktrace
      entry = @result.exceptions.first
      expect(entry.exception).to eq('java.lang.NullPointerException')
    end

    it 'should parse stacktrace correctly' do
      @parser.parse error_stacktrace
      entry = @result.exceptions.first
      expect(entry.stacktrace.size).to eq(26)
    end

  end

end