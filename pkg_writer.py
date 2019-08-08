import os,glob
adoroot = '/home/apoorval/code/misc_stata_ados/'
pkgfile = adoroot + 'lal_utilities.pkg'
os.chdir(adoroot)

ados = [file for file in glob.glob('*.ado')]
documented_ados = [line.rstrip('\n')[2:] for line in open(pkgfile) if line[0]=='f']
new_ados = list(set(ados)-set(documented_ados))
print(new_ados)
if new_ados:
    with open(pkgfile,'a') as f:
        for ado in new_ados:
            f.write('f ' + ado + '\n')
    f.close()
