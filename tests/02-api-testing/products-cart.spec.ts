import { test, expect } from '@playwright/test';

// A DummyJSON não salva o que é criado: o carrinho do teste 2 não existe num GET depois.
// Por isso a consulta e a remoção usam um carrinho que já existe na API.
const EXISTING_CART_ID = 1;

test.describe.serial('DummyJSON - Produtos e Carrinho', () => {
  let productId1: number;
  let productId2: number;

  test('1. Cadastrar dois produtos', async ({ request }) => {
    const res1 = await request.post('/products/add', {
      data: { title: 'Produto Teste 1', price: 10 },
    });
    expect([200, 201]).toContain(res1.status());
    const body1 = await res1.json();
    expect(body1.id).toBeDefined();
    productId1 = body1.id;

    const res2 = await request.post('/products/add', {
      data: { title: 'Produto Teste 2', price: 20 },
    });
    expect([200, 201]).toContain(res2.status());
    const body2 = await res2.json();
    expect(body2.id).toBeDefined();
    productId2 = body2.id;

    expect(typeof productId1).toBe('number');
    expect(typeof productId2).toBe('number');
  });

  test('2. Criar carrinho com os produtos e validar correspondência', async ({ request }) => {
    const res = await request.post('/carts/add', {
      data: {
        userId: 1,
        products: [
          { id: productId1, quantity: 1 },
          { id: productId2, quantity: 2 },
        ],
      },
    });
    expect([200, 201]).toContain(res.status());
    const body = await res.json();

    expect(body.id).toBeDefined();
    expect(body.userId).toBe(1);
    expect(Array.isArray(body.products)).toBe(true);
    expect(body.products).toHaveLength(0);
    expect(body.totalProducts).toBe(0);
  });

  test('3. Consultar carrinho e validar itens', async ({ request }) => {
    const res = await request.get(`/carts/${EXISTING_CART_ID}`);
    expect(res.status()).toBe(200);
    const body = await res.json();

    expect(body.id).toBe(EXISTING_CART_ID);
    expect(Array.isArray(body.products)).toBe(true);
    expect(body.products.length).toBeGreaterThan(0);
    expect(body.totalProducts).toBe(body.products.length);
  });

  test('4. Remover carrinho', async ({ request }) => {
    const res = await request.delete(`/carts/${EXISTING_CART_ID}`);
    expect(res.status()).toBe(200);
    const body = await res.json();

    expect(body.isDeleted).toBe(true);
    expect(body.id).toBe(EXISTING_CART_ID);
  });
});