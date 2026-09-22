from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from docx import Document
from lxml import etree

root = Path(__file__).resolve().parents[1]
report = root / 'entrega/Ficha_Laboratorio_7_MVC_DAO_Acosta_Loyola.docx'
with ZipFile(report) as z:
    assert z.testzip() is None
    for name in z.namelist():
        if name.endswith('.xml'):
            etree.fromstring(z.read(name))
doc = Document(report)
text = '\n'.join(p.text for p in doc.paragraphs)
for required in ['I. Datos generales', 'II. Logro', 'III. Actividad 1', 'IV. Actividad 2', 'V. Actividad 3', 'VI. Ticket', 'ps.setString(1, c.getNombre())', 'U22205593']:
    assert required in text, required
assert round(doc.sections[0].page_width.inches, 1) == 8.5
assert round(doc.sections[0].left_margin.inches, 1) == 1.0
out = root / 'entrega/Programa_Clientes_MVC_DAO.zip'
with ZipFile(out, 'w', ZIP_DEFLATED) as z:
    for folder in ['src', 'lib', 'database', 'config', 'scripts', 'tests', 'evidencias', 'dist']:
        for path in (root / folder).rglob('*'):
            if path.is_file() and not path.name.endswith('.properties'):
                z.write(path, 'Programa_Clientes/' + path.relative_to(root).as_posix())
    for filename in ['README.md', 'pom.xml', '.gitignore']:
        z.write(root / filename, 'Programa_Clientes/' + filename)
with ZipFile(out) as z:
    assert z.testzip() is None
    assert 'Programa_Clientes/dist/utp-clientes.war' in z.namelist()
    assert not any(n.endswith('utp-clientes.properties') for n in z.namelist())
print('DOCX: estructura XML valida y todas las actividades presentes.')
print('ZIP: integridad correcta; fuentes, dependencias, SQL, pruebas y WAR incluidos.')
print(out)
