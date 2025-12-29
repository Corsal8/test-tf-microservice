const esbuild = require('esbuild');
const { globSync } = require('glob');
const { rmSync } = require('fs');

(async () => {
  // Clean the dist directory before building
  try {
    rmSync('./dist', { recursive: true, force: true });
    console.log('Cleaned dist directory.');
  } catch (e) {
    console.error('Failed to clean dist directory:', e);
  }

  // Find all lambda entry points
  const entryPoints = globSync('./src/lambdas/**/index.ts');

  if (entryPoints.length === 0) {
    console.log('No entry points found. Exiting.');
    process.exit(0);
  }

  console.log(`Found ${entryPoints.length} entry points:`);
  console.log(entryPoints.join('\n'));

  try {
    await esbuild.build({
      entryPoints,
      bundle: true,
      platform: 'node',
      target: 'node22',
      external: ['@aws-sdk/*'], // Exclude AWS SDK from the bundle
      sourcemap: true, // Generate source maps for debugging
      minify: true, // Minify the code to reduce size
      outdir: 'dist', // Output directory
      outbase: 'src', // Strip 'src' from the output path
    });

    console.log('All lambdas built successfully!');
  } catch (err) {
    console.error('Build failed:', err);
    process.exit(1);
  }
})();
