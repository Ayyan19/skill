# Official Reference Index

**Reference index date:** 2026-11-02. URLs and documentation versions can change. Select the version matching the installed application and the exact manufacturing process.

## KiCad
- KiCad 9.0 PCB Editor manual: https://docs.kicad.org/9.0/en/pcbnew/pcbnew.html
- KiCad 9.0 CLI manual: https://docs.kicad.org/9.0/en/cli/cli.html
- KiCad documentation portal: https://docs.kicad.org/

Useful CLI capabilities documented by KiCad include PCB DRC, Gerber export, drill export, position-file export, and STEP export. Confirm exact command syntax with the installed `kicad-cli --help` and the matching-version manual. In KiCad 9, `pcb export gerber` (singular) is deprecated; use `pcb export gerbers` (plural) for one layer per output file where appropriate.

## Altium Designer
- Design Rule Check: https://www.altium.com/documentation/altium-designer/pcb/drc
- Setting up and running DRC: https://www.altium.com/documentation/altium-designer/pcb/drc/setting-up-running
- Preparing manufacturing data with Output Jobs: https://www.altium.com/documentation/altium-designer/preparing-for-manufacture/output-jobs
- Preparing your design for manufacture: https://www.altium.com/documentation/altium-designer/preparing-for-manufacture
- Project release: https://www.altium.com/documentation/altium-designer/preparing-for-manufacture/design-release

## EasyEDA
- EasyEDA Standard DRC guide: https://docs.easyeda.com/en/PCB/Design-Rule-Check/
- EasyEDA PCB export guide: https://docs.easyeda.com/en/Export/Export-PCB
- EasyEDA documentation: https://docs.easyeda.com/

Confirm whether the project is EasyEDA Standard or Pro; project and export capabilities can differ.

## IPC
- IPC standards overview: https://www.ipc.org/standards
- IPC public standards checklist: https://www.ipc.org/media/8964/download
- IPC standards tree: https://www.ipc.org/media/8500/download

Relevant standard families may include:
- IPC-2221 / IPC-2222: generic and sectional printed board design.
- IPC-2152: current-carrying capacity in printed board design.
- IPC-7351 / IPC-7352: surface-mount land pattern guidance.
- IPC-261x: electronic product and fabrication documentation.
- IPC-6012: qualification/performance specification for rigid printed boards.
- IPC-2581: intelligent data exchange format.

Verify the current edition, amendment, applicability, class, and product requirements. IPC standards are copyrighted; this index does not reproduce their normative content.

## Gerber and CAM
- Ucamco Gerber resources: https://www.ucamco.com/en/gerber
- KiCad Gerber export documentation: see KiCad CLI and PCB Editor manuals above.

## Usage rules
1. Prefer primary documentation and exact part datasheets.
2. Confirm tool version before using CLI syntax or interpreting a report.
3. Use the actual fabricator/assembler capability document and quote.
4. Do not treat a standard's name as proof of compliance.
5. Do not claim a CAM, DRC, impedance, thermal, EMI, or safety check was performed unless evidence is available.
