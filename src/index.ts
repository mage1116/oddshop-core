export interface Env {
  DB: D1Database;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    if (url.pathname === "/health") {
      await env.DB.prepare("SELECT 1").first();
      return Response.json({ ok: true });
    }
    return new Response("oddshop-core", { status: 200 });
  },
} satisfies ExportedHandler<Env>;
