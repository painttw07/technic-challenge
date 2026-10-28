const fs = require('fs');
const path = require('path');
const dns = require('dns').promises;

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

async function validar(email) {
  if (!EMAIL_REGEX.test(email)) {
    return [email, 'Inválido', 'Sintaxe inválida'];
  }

  const dominio = email.split('@')[1];
  try {
    await dns.resolveMx(dominio);
    return [email, 'Válido', ''];
  } catch {
    return [email, 'Inválido', 'Domínio não encontrado'];
  }
}

async function main() {
  const emails = fs
    .readFileSync(path.join(__dirname, 'emails.txt'), 'utf8')
    .split('\n')
    .map((linha) => linha.trim())
    .filter(Boolean);

  const linhas = ['email,status,motivo'];
  for (const email of emails) {
    const resultado = await validar(email);
    linhas.push(resultado.join(','));
  }

  fs.writeFileSync(path.join(__dirname, 'validacao_emails.csv'), linhas.join('\n') + '\n');
  console.log(linhas.join('\n'));
}

main();
