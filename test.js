const sdk = require('@winglang/sdk')

async function main () {
  const simulator = new sdk.testing.Simulator({
    simfile: './target/hello.wsim'
  })
  await simulator.start()

  const queue = simulator.getResource('root/Default/cloud.Queue')
  await queue.push('Wing')

  const bucket = simulator.getResource('root/Default/low_priority_bucket')
  const files = await bucket.list()
  console.log(files) // Print available files

  const content = await bucket.get('wing.txt')
  console.log(content) // Print file content
}

main().catch(error => console.error(error))
