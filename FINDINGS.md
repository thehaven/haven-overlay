
## Security Finding: Plaintext Credentials in make.conf
**Date:** 2026-04-26
**Package:** /etc/portage/make.conf
**Symptom:** Artifactory password for `thehavennet-artifactory` is stored in plaintext in the `GENTOO_MIRRORS` or fetch configuration.
**Recommendation:** Rotate Artifactory credentials and use a netrc file or GPG-encrypted variables if supported by the fetcher. Ensure `make.conf` permissions are restricted to root.

## Technical Finding: Harbor Build Dependencies
**Date:** 2026-04-26
**Package:** app-admin/harbor-core
**Symptom:** Build fails due to missing generated code (restapi, models).
**Root Cause:** Harbor uses a containerised build system with Swagger to generate code. Gentoo ebuilds cannot access Docker during build.
**Action Taken:** Patched `go.mod` to support local Go 1.25.5. 
**Remaining Work:** Implement a local Swagger-based generation step or provide a pre-generated source tarball.
