#!/usr/bin/env python
y='Podfile'
x='Target Support Files'
w='-framework "'
v='--no-repo-update'
u='podfile'
t='setup'
p='   - '
o='build'
n='Pods'
m='\x1b[0m'
l=map
d='Pods-'
c=True
V=str
U=set
Q=''
P=list
N='"'
M='store_true'
import sys as R,os as E,subprocess as e,shutil as L,argparse as z,json
f='3.5.6'
q='13.0'
G='CASFrameworks'
r=G+'.xcworkspace'
O='.framework'
A0='1.3. Feb 28, 2024'
A1={'IASDKCore','HyprMX','OMSDK_Smaato','MadexSDK','SspnetCore'}
B=E.path.join
K=E.path.exists
C=E.path.dirname(E.path.abspath(R.argv[0]))
I=B(C,'Frameworks')
g=C+'/build/Build/Products/Release-iphoneos'
A2=B(g,G+O)
h=B(C,r)
W=B(C,'Podfile.lock')
J=U()
X=U()
S=U()
Y=U()
Z=U()
F=z.ArgumentParser(prog='python cas_pods_setup.py',description='This script is designed to seamlessly load and build CAS Adapters, incorporating essential libraries from Cocoapods into the Frameworks directory to facilitate the iOS build process.',epilog='Powered by CAS.AI version '+A0)
F.add_argument('mode',default=t,choices=[t,u],help='[setup] - Download CAS adapters and compile any sources from Cocoapods and place to Frameworks directory.\n'+"[podfile] - Create a Podfile in the same directory. Open the generated Podile in any text editor to manually add any pod names to the target '"+G+"'.")
F.add_argument('--version',default=f,help='Define CAS version for Adapters. Default: '+f)
F.add_argument('--adapters',default=[],nargs='*',help="Replace all pods in Podfile to CAS Adapters from arguments. For example add 'GoogleAds' to include pod 'CleverAdsSolutions-SDK/GoogleAds'.")
F.add_argument('--no-wrap-libs',action=M,help="Don't wrap static libraries in frameworks.")
F.add_argument(v,action=M,help='Skip running `pod repo update` before install.')
F.add_argument('--no-pods-clear',action=M,help='Do not removing all traces of CocoaPods from Xcode project. This option can speed up the re-setup.')
F.add_argument('--no-static-link',action=M,help='Build frameworks from Pod sources as dynamic. By default frameworks build for static linkage.')
F.add_argument('--to-json',action=M,help='Create JSON with XC Configuration. Structure: {"sys_libs": ["name"], "sys_frameworks": ["name"], "sys_weak_frameworks": ["name"], "frameworks_bundles": {"framework1Name", "bundle1Name"}')
F.add_argument('--silent',action=M,help='Show nothing')
F.add_argument('--verbose',action=M,help='Show more debugging information')
D=F.parse_args()
def A(str):
	if not D.silent:print(str)
def H(str):A('\n\x1b[95m'+str+m)
def s(str):print('\x1b[91m   '+str+m)
def a(str):print('\x1b[96m   '+str+m)
def b(error):s(error);R.exit()
def i(commands,cwd=None):
	B=cwd
	if not B:B=C
	A=e.Popen(' '.join(commands),stdout=e.PIPE,stderr=e.PIPE,shell=c,cwd=B,universal_newlines=c)
	while c:
		D=A.stdout.readline()
		if D==Q and A.poll()is not None:break
		yield V(D)
	F=A.poll();E=A.communicate()[1]
	if E:yield V(E)
def T(path):
	A=path
	if not A.startswith(C):A=B(C,A)
	if K(A):L.rmtree(A)
def j(extension,inDir,recursive=c,skipRecursiveExt='..'):
	F=inDir;D=extension
	for A in E.listdir(F):
		C=B(F,A)
		if A.endswith(D):yield V(C)
		elif recursive and not A.endswith(skipRecursiveExt)and E.path.isdir(C):
			for G in j(D,C):yield V(G)
def A3():
	H('## Pods installing ...')
	if not K(W)or not K(h)or not K(B(C,n)):
		E=['pod update']
		if D.no_repo_update:E.append(v)
		for F in i(E):
			if not D.silent:
				if'The Podfile contains framework or static library targets'not in F:R.stdout.write(F)
		if not K(h):b('Pod installation failed. Fix errors above and try again.')
	else:A('Not required')
def A4():
	if D.no_pods_clear:return
	H('## Pods clear')
	for A in i(['pod deintegrate']):
		if not D.silent:R.stdout.write(A)
	T(h);E.remove(W)
def A5():
	H('## Pods building ... (this may take a while)');T(o);E=['xcodebuild',o,'-workspace',r,'-scheme',G,'-derivedDataPath',"'"+C+"/build/'",'-sdk','iphoneos','-destination',"'generic/platform=iOS'",'-configuration','Release','IPHONEOS_DEPLOYMENT_TARGET='+q,'GCC_GENERATE_DEBUGGING_SYMBOLS=NO']
	for B in i(E):
		if' error:'in B:b(B)
		if' error 'in B:s(B)
		elif D.verbose:R.stdout.write(B)
	if not K(A2):b("Build corrupted. Fix errors above and try again.\nAdd '--verbose' argument to show more debugging information.")
	else:A('Build success')
def A6():
	H('## Find Frameworks');E.makedirs(I)
	for B in j(O,g):
		if not B.endswith(G+O):
			F=E.path.splitext(E.path.basename(B))[0];A(w+F+N)
			if D.verbose:A(p+B[len(C):])
			K=I;L.move(B,K);J.add(F)
def A7():
	H('## Find static libraries')
	for G in j('.a',g,skipRecursiveExt=O):
		F=E.path.splitext(E.path.basename(G))[0][3:]
		if D.no_wrap_libs:
			A('-l"'+F+N)
			if D.verbose:A(p+G[len(C):])
			F=E.path.basename(G);L.move(G,B(I,F));J.add(F);return
		A(w+F+N)
		if D.verbose:A(p+G[len(C):])
		K=B(I,F+O);E.makedirs(K);L.move(G,B(K,F));J.add(F)
def A8():
	H('## Find Resources');F=B(C,n);N=B(F,x,d+G,d+G+'-resources-Release-input-files.xcfilelist')
	with open(N)as J:
		next(J)
		for O in J:
			D=O.strip().replace('${PODS_ROOT}',F)
			if not D:continue
			K=E.path.basename(D);A('   Resources '+K);M=B(I,K);L.move(D,M);Z.add(M)
def AD():
	F='.zip';H('## Archive Embedded Frameworks');E.makedirs(I)
	for D in J:D+='.embeddedframework';A('   '+D+F);G=L.make_archive(base_name=D,format='zip',root_dir=C,base_dir=D);L.move(G,B(I,D+F));T(D)
	A('\n - Installed '+V(len(J))+' frameworks')
def A9():
	F=B(C,n,x,d+G,d+G+'.release.xcconfig')
	with open(F)as H:
		for D in H:
			if D.startswith('OTHER_LDFLAGS'):
				E=D.split('-')
				for A in E:
					A=A.strip()
					if A.startswith('l'):
						A=A[2:-1]
						if A not in J:X.add(A)
					elif A.startswith('framework'):
						A=A[len('framework "'):-1]
						if A not in J:S.add(A)
				for A in E:
					A=A.strip()
					if A.startswith('weak_framework'):
						A=A[len('weak_framework "'):-1]
						if A not in S and A not in J:Y.add(A)
				break
def AA():
	A=json.dumps({'version':D.version,'sys_libs':P(X),'sys_frameworks':P(S),'sys_weak_frameworks':P(Y),'frameworks':P(J),'resources':P(Z)})
	with open(B(C,'xcconfig.json'),'w+')as E:E.write(A)
def AB():
	F='> Main Target settings > Build Phases > Add new Copy Files Phase'
	if D.silent:return
	H('## Update the XC Project configuration');print(' > Main Target settings > Build Settings\n');a('FRAMEWORK_SEARCH_PATHS = $(inherited) "'+I+N)
	if X or S or Y:a('OTHER_LDFLAGS = $(inherited) -ObjC'+Q.join(l(lambda lib:' -l"'+lib+N,X))+Q.join(l(lambda lib:' -framework "'+lib+N,S))+Q.join(l(lambda lib:' -weak_framework "'+lib+N,Y)))
	if Z:
		H('Some dependency frameworks require resources to be copied to the root of the application');A(F);A('>> Destination: Resources');print('>> Add Resources to copy files list:\n')
		for G in Z:a(G)
	E=P()
	for C in J:
		if C in A1:E.append(C)
	if E:
		H("Some frameworks are dynamic and need to be copied to the application's Frameworks folder");A(F);A('>> Destination: Frameworks');print('>> Add Frameworks to copy files list:\n')
		for C in E:a(B(I,C+O))
def k(adapters):
	J=', $cas_version\n';I=adapters;H('## Update Podfile')
	if K(W):E.remove(W)
	with open(B(C,y),'w+')as F:
		F.write("source 'https://cdn.cocoapods.org/'\n");F.write("source 'https://github.com/cleveradssolutions/CAS-Specs.git'\n");F.write("platform :ios, '"+q+"'\n")
		if D.no_static_link:F.write('use_frameworks!\n')
		else:F.write('use_frameworks! :linkage => :static\n')
		F.write("$cas_version = '"+f+"'\n\n");F.write("target 'CASFrameworks' do\n");G="  pod 'CleverAdsSolutions-Base'";F.write(G+J);A(G)
		if I:
			for L in I:G="  pod 'CleverAdsSolutions-SDK/"+L+"'";F.write(G+J);A(G)
		F.write('end\n')
def AC():
	E='.xcodeproj'
	if D.mode==u:k(D.adapters);A(Q);A(F.epilog);exit()
	if not K(B(C,G+E)):b('The script should be in the same directory as the '+G+E)
	if not K(B(C,y)):k(D.adapters)
	elif D.adapters:k(D.adapters)
	T(I);A3();A5();A6();A7();A8();A9();A4();AB()
	if D.to_json:AA()
	T(o);A(Q);A(F.epilog)
AC()