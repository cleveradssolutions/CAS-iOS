#!/usr/bin/env python
z='Podfile'
y='Target Support Files'
x='-framework "'
w='--no-repo-update'
v='podfile'
u='setup'
q='   - '
p='build'
o='Pods'
n='\x1b[0m'
m=map
e='Pods-'
d='.embeddedframework'
c=True
b=list
V=str
U=set
P='"'
O=''
L='store_true'
import sys as Q,os as E,subprocess as f,shutil as M,argparse as A0,json
g='3.4.1'
A1='13.0'
G='CASFrameworks'
r=G+'.xcworkspace'
N='.framework'
A2='1.1. Nov 13, 2023'
A3={'OMSDK_Bigosg','IASDKCore','HyprMX','OMSDK_Smaato'}
A=E.path.join
K=E.path.exists
C=E.path.dirname(E.path.abspath(Q.argv[0]))
J=A(C,'Frameworks')
h=C+'/build/Build/Products/Release-iphoneos'
A4=A(h,G+N)
i=A(C,r)
W=A(C,'Podfile.lock')
H=U()
X=U()
R=U()
Y=U()
Z=U()
F=A0.ArgumentParser(prog='python cas_pods_setup.py',description='This script is designed to seamlessly load and build CAS Adapters, incorporating essential libraries from Cocoapods into the Frameworks directory to facilitate the iOS build process.',epilog='Powered by CAS.AI version '+A2)
F.add_argument('mode',default=u,choices=[u,v],help='[setup] - Download CAS adapters and compile any sources from Cocoapods and place to Frameworks directory.\n'+"[podfile] - Create a Podfile in the same directory. Open the generated Podile in any text editor to manually add any pod names to the target '"+G+"'.")
F.add_argument('--version',default=g,help='Define CAS version for Adapters. Default: '+g)
F.add_argument('--adapters',default=[],nargs='*',help="Replace all pods in Podfile to CAS Adapters from arguments. For example add 'GoogleAds' to include pod 'CleverAdsSolutions-SDK/GoogleAds'.")
F.add_argument('--no-wrap-libs',action=L,help="Don't wrap static libraries in frameworks.")
F.add_argument(w,action=L,help='Skip running `pod repo update` before install.')
F.add_argument('--no-pods-clear',action=L,help='Do not removing all traces of CocoaPods from Xcode project. This option can speed up the re-setup.')
F.add_argument('--no-static-link',action=L,help='Build frameworks from Pod sources as dynamic. By default frameworks build for static linkage.')
F.add_argument('--embed-archive',action=L,help='All required frameworks will be embedded and zipped (.embeddedframework.zip). Can be used from the Unreal Engine.')
F.add_argument('--to-json',action=L,help='Create JSON with XC Configuration. Structure: {"sys_libs": ["name"], "sys_frameworks": ["name"], "sys_weak_frameworks": ["name"], "frameworks_bundles": {"framework1Name", "bundle1Name"}')
F.add_argument('--silent',action=L,help='Show nothing')
F.add_argument('--verbose',action=L,help='Show more debugging information')
B=F.parse_args()
def D(str):
	if not B.silent:print(str)
def I(str):D('\n\x1b[95m'+str+n)
def s(str):print('\x1b[91m   '+str+n)
def a(str):print('\x1b[96m   '+str+n)
def S(error):s(error);Q.exit()
def j(commands,cwd=None):
	B=cwd
	if not B:B=C
	A=f.Popen(' '.join(commands),stdout=f.PIPE,stderr=f.PIPE,shell=c,cwd=B,universal_newlines=c)
	while c:
		D=A.stdout.readline()
		if D==O and A.poll()is not None:break
		yield V(D)
	F=A.poll();E=A.communicate()[1]
	if E:yield V(E)
def T(path):
	B=path
	if not B.startswith(C):B=A(C,B)
	if K(B):M.rmtree(B)
def k(extension,inDir,recursive=c,skipRecursiveExt='..'):
	F=inDir;D=extension
	for B in E.listdir(F):
		C=A(F,B)
		if B.endswith(D):yield V(C)
		elif recursive and not B.endswith(skipRecursiveExt)and E.path.isdir(C):
			for G in k(D,C):yield V(G)
def A5():
	I('## Pods installing ...')
	if not K(W)or not K(i)or not K(A(C,o)):
		E=['pod update']
		if B.no_repo_update:E.append(w)
		for F in j(E):
			if not B.silent:
				if'The Podfile contains framework or static library targets'not in F:Q.stdout.write(F)
		if not K(i):S('Pod installation failed. Fix errors above and try again.')
	else:D('Not required')
def A6():
	if B.no_pods_clear:return
	I('## Pods clear')
	for A in j(['pod deintegrate']):
		if not B.silent:Q.stdout.write(A)
	T(i);E.remove(W)
def A7():
	I('## Pods building ... (this may take a while)');T(p);E=['xcodebuild',p,'-workspace',r,'-scheme',G,'-derivedDataPath',"'"+C+"/build/'",'-sdk','iphoneos','-destination',"'generic/platform=iOS'",'-configuration','Release']
	for A in j(E):
		if' error:'in A:S(A)
		if' error 'in A:s(A)
		elif B.verbose:Q.stdout.write(A)
	if not K(A4):S("Build corrupted. Fix errors above and try again.\nAdd '--verbose' argument to show more debugging information.")
	else:D('Build success')
def A8():
	I('## Find Frameworks');E.makedirs(J)
	for F in k(N,h):
		if not F.endswith(G+N):
			K=E.path.splitext(E.path.basename(F))[0];D(x+K+P)
			if B.verbose:D(q+F[len(C):])
			if B.embed_archive:L=A(C,K+d);E.makedirs(L)
			else:L=J
			M.move(F,L);H.add(K)
def A9():
	I('## Find static libraries')
	for G in k('.a',h,skipRecursiveExt=N):
		F=E.path.splitext(E.path.basename(G))[0][3:]
		if B.no_wrap_libs:
			D('-l"'+F+P)
			if B.verbose:D(q+G[len(C):])
			F=E.path.basename(G);M.move(G,A(J,F));H.add(F);return
		D(x+F+P)
		if B.verbose:D(q+G[len(C):])
		if B.embed_archive:K=A(C,F+d,F+N)
		else:K=A(J,F+N)
		E.makedirs(K);M.move(G,A(K,F));H.add(F)
def AA():
	I('## Find Resources');L=A(C,o);O=A(L,y,e+G,e+G+'-resources-Release-input-files.xcfilelist')
	with open(O)as N:
		next(N)
		for P in N:
			H=P.strip().replace('${PODS_ROOT}',L)
			if not H:continue
			F=E.path.basename(H);D('   Resources '+F)
			if B.embed_archive:Q=t(F);K=A(C,Q+d,F)
			else:K=A(J,F)
			M.move(H,K);Z.add(K)
def t(bundleName):
	A=bundleName
	if A.startswith('CASBase'):return'CleverAdsSolutions'
	if A=='MobileAdsBundle.bundle':return'YandexMobileAds'
	for B in H:
		if A.startswith(B):return B
	S(A+' is not associated with any framework. Please update Build logic to fix it.')
def AB():
	F='.zip';I('## Archive Embedded Frameworks');E.makedirs(J)
	for B in H:B+=d;D('   '+B+F);M.make_archive(base_name=B,format='zip',root_dir=C,base_dir=B);M.move(B+F,A(J,B+F));T(B)
	D('\n - Installed '+V(len(H))+' frameworks')
def AC():
	F=A(C,o,y,e+G,e+G+'.release.xcconfig')
	with open(F)as I:
		for D in I:
			if D.startswith('OTHER_LDFLAGS'):
				E=D.split('-')
				for B in E:
					B=B.strip()
					if B.startswith('l'):
						B=B[2:-1]
						if B not in H:X.add(B)
					elif B.startswith('framework'):
						B=B[len('framework "'):-1]
						if B not in H:R.add(B)
				for B in E:
					B=B.strip()
					if B.startswith('weak_framework'):
						B=B[len('weak_framework "'):-1]
						if B not in R and B not in H:Y.add(B)
				break
def AD():
	D=dict();F=H.copy()
	for J in Z:
		N,I=E.path.split(J);G=t(I)
		if G in F:F.remove(G);D[G]=I
	for K in F:D[K]=O
	L=json.dumps({'version':B.version,'sys_libs':b(X),'sys_frameworks':b(R),'sys_weak_frameworks':b(Y),'frameworks_bundles':D})
	with open(A(C,'xcconfig.json'),'w+')as M:M.write(L)
def AE():
	F='> Main Target settings > Build Phases > Add new Copy Files Phase'
	if B.silent:return
	I('## Update the XC Project configuration');print(' > Main Target settings > Build Settings\n');a('FRAMEWORK_SEARCH_PATHS = $(inherited) "'+J+P)
	if X or R or Y:a('OTHER_LDFLAGS = $(inherited) -ObjC'+O.join(m(lambda lib:' -l"'+lib+P,X))+O.join(m(lambda lib:' -framework "'+lib+P,R))+O.join(m(lambda lib:' -weak_framework "'+lib+P,Y)))
	if Z:
		I('Some dependency frameworks require resources to be copied to the root of the application');D(F);D('>> Destination: Resources');print('>> Add Resources to copy files list:\n')
		for G in Z:a(G)
	E=b()
	for C in H:
		if C in A3:E.append(C)
	if E:
		I("Some frameworks are dynamic and need to be copied to the application's Frameworks folder");D(F);D('>> Destination: Frameworks');print('>> Add Frameworks to copy files list:\n')
		for C in E:a(A(J,C+N))
def l(adapters):
	J=', $cas_version\n';H=adapters;I('## Update Podfile')
	if K(W):E.remove(W)
	with open(A(C,z),'w+')as F:
		F.write("source 'https://cdn.cocoapods.org/'\n");F.write("source 'https://github.com/cleveradssolutions/CAS-Specs.git'\n");F.write("platform :ios, '"+A1+"'\n")
		if B.no_static_link:F.write('use_frameworks!\n')
		else:F.write('use_frameworks! :linkage => :static\n')
		F.write("$cas_version = '"+g+"'\n\n");F.write("target 'CASFrameworks' do\n");G="  pod 'CleverAdsSolutions-Base'";F.write(G+J);D(G)
		if H:
			for L in H:G="  pod 'CleverAdsSolutions-SDK/"+L+"'";F.write(G+J);D(G)
		F.write('end\n')
def AF():
	E='.xcodeproj'
	if B.mode==v:l(B.adapters);D(O);D(F.epilog);exit()
	if not K(A(C,G+E)):S('The script should be in the same directory as the '+G+E)
	if not K(A(C,z)):l(B.adapters)
	elif B.adapters:l(B.adapters)
	T(J);A5();A7();A8();A9();AA();AC();A6()
	if B.embed_archive:AB()
	else:AE()
	if B.to_json:AD()
	T(p);D(O);D(F.epilog)
AF()