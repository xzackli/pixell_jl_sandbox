using Pixell
gr()
default(dpi=200, fontfamily="Computer Modern")

mI = read_map(joinpath(ENV["SCRATCH"], "act", "ACTPol_148_D56_pa1_f150_s14_4way_split0_srcadd_I.fits"))
mQ = read_map(joinpath(ENV["SCRATCH"], "act", "ACTPol_148_D56_pa1_f150_s14_4way_split0_Q.fits"))
mU = read_map(joinpath(ENV["SCRATCH"], "act", "ACTPol_148_D56_pa1_f150_s14_4way_split0_U.fits"))

plot(mI[1:4:end, 1:4:end], clim=(-400, 400))

##

using BenchmarkTools
@btime aE, aB = map2alm((mQ, mU); lmax=10_000)


##
using PythonCall
np = pyimport("numpy")
pyenmap = pyimport("pixell.enmap")
pycurvedsky = pyimport("pixell.curvedsky")

pyI = pyenmap.read_map(joinpath(ENV["SCRATCH"], "act", "ACTPol_148_D56_pa1_f150_s14_4way_split0_srcadd_I.fits"))
pyQ = pyenmap.read_map(joinpath(ENV["SCRATCH"], "act", "ACTPol_148_D56_pa1_f150_s14_4way_split0_Q.fits"))
pyU = pyenmap.read_map(joinpath(ENV["SCRATCH"], "act", "ACTPol_148_D56_pa1_f150_s14_4way_split0_U.fits"))
qu = pyenmap.zeros((2, pyQ.shape...), wcs=pyQ.wcs)
a, b = qu
np.copyto(a, pyQ)
np.copyto(b, pyU)

##
@btime aEpy, aBpy = pycurvedsky.map2alm(qu, lmax=10_000, spin=2)


# @time aIpy = pycurvedsky.map2alm(pyI, lmax=10, spin=0)

# aIp = PyArray(aEpy)
##
plot((real.(PyArray(aEpy)) ./ real.(aE.alm))[5:100], ylim=(0.9,1.1))

# plot(alm2cl(aE₀, aE₁)[1:3000] .* collect(1:3000).^2)
# ENV["OMP_NUM_THREADS"]

##
# histogram(imag.(aE.alm))
plot(1:10, size=(400,300))

##
