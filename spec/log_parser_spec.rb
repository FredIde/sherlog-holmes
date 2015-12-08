require 'spec_helper'

describe Parser do

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
END
    end

    let(:error_multiline) do
      <<END.chomp
18:53:20,034 ERROR [tools.devnull.logspitter] (default-workqueue-1) Something wrong happened:
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
END
    end

    def log(*lines)
      lines.join $/
    end

    before(:each) do
      @filter = double Filter
      allow(@filter).to receive(:accept?).and_return(true)

      @parser = Parser::new
      @parser.filter @filter
      @parser.patterns entry: /
                                (?<time>[0-9,.:]+)
                                \s+
                                (?<level>\w+)
                                \s+
                                \[(?<category>\S+)\]
                                \s
                                \((?<origin>[^)]+)\)?\s?
                                (?<message>.+)
                              /x,
                       exception: /(?<exception>\w+(\.\w+)+(Exception|Error))/,
                       stacktrace: /^(\s+at)|(Caused by)/
      @result = @parser.collect
    end

    it 'should use the given filter' do
      @parser.parse log(info_line, info_line)

      expect(@filter).to have_received(:accept?).exactly(2).times
    end

    it 'should store the raw content of entries' do
      input = [info_line, info_multiline].join $/
      @parser.parse input

    end

    it 'should call listeners' do
      listener = double 'listener'
      allow(listener).to receive(:call)
      @parser.on_new_entry listener
      @parser.parse log(info_line, info_line)
      expect(listener).to have_received(:call).exactly(2).times
    end

    it 'should parse multiline messages' do
      @parser.parse info_multiline
      expect(@result.entries.first.message).to eq(<<END.chomp)
JBWS024061: Adding service endpoint metadata: id=tools.devnull.logspitter.LogSpitterService
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

    it 'should parse an exception message' do
      @parser.parse(error_stacktrace)
      expect(@result.exceptions.size).to eq(1)
      expect(@result.exceptions.first.exception?).to be_truthy
      expect(@result.exceptions.first.stacktrace.size).to eq(12)
    end

    it 'should not parse a stacktrace if entry is not an exception' do
      @parser.parse(error_multiline)
      expect(@result.exceptions.empty?).to be_truthy
    end

  end

end