<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
	integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/all_component/style.css">

<style>
	.track {
		display: flex;
		justify-content: space-between;
		margin-top: 10px;
		position: relative;
	}

	.track::before {
		content: '';
		position: absolute;
		top: 50%;
		left: 0;
		width: 100%;
		height: 4px;
		background: #ddd;
		transform: translateY(-50%);
	}

	.step {
		position: relative;
		z-index: 2;
		width: 33%;
		text-align: center;
	}

	.step span {
		display: inline-block;
		width: 32px;
		height: 32px;
		border-radius: 50%;
		background: #ddd;
		line-height: 32px;
		color: #fff;
	}

	.step.active span {
		background: #28a745;
	}

	.step p {
		margin-top: 6px;
		font-size: 13px;
	}

	.cancelled-text {
		color: #dc3545;
		font-weight: bold;
		text-align: center;
	}

	.toast {
		position: fixed;
		bottom: 30px;
		right: 30px;
		background: #333;
		color: white;
		padding: 12px 20px;
		border-radius: 6px;
		opacity: 0;
		pointer-events: none;
		transition: 0.4s;
		z-index: 9999;
	}

	.toast.show {
		opacity: 1;
	}

	.toast.success {
		background: #28a745;
	}

	.toast.error {
		background: #dc3545;
	}

	.toast.warn {
		background: #ffc107;
		color: black;
	}
</style>

<div id="toast" class="toast"></div>

<script>
	function showToast(msg, type) {
		let t = document.getElementById("toast");
		if (!t) return;

		t.className = "toast show " + type;
		t.innerText = msg;

		setTimeout(() => {
			t.className = "toast";
		}, 2000);
	}
	
</script>